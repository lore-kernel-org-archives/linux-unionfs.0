From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [GIT PULL] overlay filesystem v25
Date: Mon, 27 Oct 2014 08:59:01 -0700
Message-ID: <20141027155901.GE5718@linux.vnet.ibm.com>
References: <20141023232539.GA4662@tucsk.piliscsaba.szeredi.hu>
 <20141024022055.GH7996@ZenIV.linux.org.uk>
 <20141024032422.GI7996@ZenIV.linux.org.uk>
 <CAJfpegt-X_Cd8B5H65keshhhuwH2-HPpaBC30atKeS3QjaariA@mail.gmail.com>
 <20141025081845.GJ7996@ZenIV.linux.org.uk>
 <CAJfpegvM8d-cizf=3KmTSFVgAYPBDp_0fQAh+G2Q87u=taXm3A@mail.gmail.com>
 <20141025170609.GK7996@ZenIV.linux.org.uk>
 <CAJfpegucroRzo0NHTz=4N0WcrB2oDC0eDiZXk=aKSjc8vdYDjw@mail.gmail.com>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJfpegucroRzo0NHTz=4N0WcrB2oDC0eDiZXk=aKSjc8vdYDjw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Mon, Oct 27, 2014 at 09:06:54AM +0100, Miklos Szeredi wrote:
> [Paul McKenney added to CC]
> 
> On Sat, Oct 25, 2014 at 7:06 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > On Sat, Oct 25, 2014 at 11:53:52AM +0200, Miklos Szeredi wrote:
> >
> >> Yes, but it's not about race with copy-up (which the ovl_path_upper()
> >> protects against), but race of two fsync calls with each other.  If
> >> there's no synchronization between them, then that od->upperfile does
> >> indeed count as lockless access, no matter that the assignment was
> >> done under lock.
> >
> >         p = global;
> >         if (!p) {       // outside of lock
> >                 p = alloc();
> >                 grab lock
> >                 if (!global) {
> >                         global = p;
> >                 } else {
> >                         destroy(p);
> >                         p = global;
> >                 }
> >                 drop lock
> >         }
> > is a very common pattern, especially if you look for cases when lock is
> > a spinlock and allocation is blocking (in those cases you'll often see
> > destroy() part done after dropping the lock; that's where what I fucked up in
> > what I'd originally pushed.  And it wasn't even needed - fput() under
> > ->i_mutex is OK...)
> 
> Being a very common pattern does not automatically make it correct...
> 
> My understanding of these issues is very limited, but it's not clear
> to me what will order initialization of members of p with the storing
> of p into global.  E.g. we start out with global == NULL and p->foo ==
> 0.
> 
> CPU1:
>   p->foo = 1
>   grab lock
>   if (!global)
>       global = p
> 
> CPU1:

If it is all the same to you, I will call this CPU2 to distinguish it from
the first CPU1.  ;-)

>   p = global
>   if (p)
>      q = p->foo
> 
> Is it guaranteed that the above sequence (as is, without any barriers
> or ACCESS_ONCE() other than the lock acquisition) will result in q ==
> 1 if p != NULL?

Indeed, life is hard here.  Keep in mind that lock acquisition is not
guaranteed to prevent prior operations from being reordered into the
critical section, possibly as follows:

	CPU1:
	  grab lock
	  if (!global)
	      global = p;
	  /* Assume all of CPU2's accesses happen here. */
	  p->foo = 1;

This clearly allows CPU2 to execute as follows:

	CPU2:
	  p = global; /* gets p */
	  if (p) /* non-NULL */
	  	q = p->foo; /* might not be 1 */

Not only that, on DEC Alpha, even if CPU1's accesses are ordered, CPU2's
accesses can be misordered.  You need rcu_dereference() or the combination
of ACCESS_ONCE() and smp_read_barrier_depends() to avoid this issue.
As always, see http://www.openvms.compaq.com/wizard/wiz_2637.html for
more info.

So no, there is no guarantee.  I am assuming that the lock grabbed by
CPU1 guards all assignments to "global", otherwise the code needs further
help.  I am further assuming that the memory pointed to by CPU1's "p"
is inaccessible to any other CPU, as in CPU1 just allocated the memory.
Otherwise, the assignment "p->foo = 1" is questionable.  And finally,
I am assuming that p->foo stays constant once it has been made
accessible to readers.

But the following should work:

	CPU1:
	  p->foo = 1;  /* Assumes p is local. */
	  smp_mb__before_spinlock();
	  grab lock
	  if (!global)  /* Assumes lock protects all assignments to global. */
	      global = p;

	CPU2:
	  p = rcu_dereference(global);
	  if (p)
	     q = p->foo; /* Assumes p->foo constant once visible to readers. */
	     		 /* Also assumes p and q are local. */

If the assumptions called out in the comments do not hold, you at least
need ACCESS_ONCE(), and perhaps even more synchronization.  For more info
on ACCESS_ONCE(), Jon's LWN article is at http://lwn.net/Articles/508991/.

								Thanx, Paul
