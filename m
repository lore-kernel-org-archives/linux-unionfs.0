From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [GIT PULL] overlay filesystem v25
Date: Mon, 27 Oct 2014 17:28:01 +0000
Message-ID: <20141027172800.GW7996@ZenIV.linux.org.uk>
References: <20141023232539.GA4662@tucsk.piliscsaba.szeredi.hu>
 <20141024022055.GH7996@ZenIV.linux.org.uk>
 <20141024032422.GI7996@ZenIV.linux.org.uk>
 <CAJfpegt-X_Cd8B5H65keshhhuwH2-HPpaBC30atKeS3QjaariA@mail.gmail.com>
 <20141025081845.GJ7996@ZenIV.linux.org.uk>
 <CAJfpegvM8d-cizf=3KmTSFVgAYPBDp_0fQAh+G2Q87u=taXm3A@mail.gmail.com>
 <20141025170609.GK7996@ZenIV.linux.org.uk>
 <CAJfpegucroRzo0NHTz=4N0WcrB2oDC0eDiZXk=aKSjc8vdYDjw@mail.gmail.com>
 <20141027155901.GE5718@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141027155901.GE5718@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Linus Torvalds <torvalds@linux-foundation.org>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Mon, Oct 27, 2014 at 08:59:01AM -0700, Paul E. McKenney wrote:

> Indeed, life is hard here.  Keep in mind that lock acquisition is not
> guaranteed to prevent prior operations from being reordered into the
> critical section, possibly as follows:
> 
> 	CPU1:
> 	  grab lock
> 	  if (!global)
> 	      global = p;
> 	  /* Assume all of CPU2's accesses happen here. */
> 	  p->foo = 1;

A bit of context: p is a local pointer to struct file here and alloc is
opening it...

> This clearly allows CPU2 to execute as follows:
> 
> 	CPU2:
> 	  p = global; /* gets p */
> 	  if (p) /* non-NULL */
> 	  	q = p->foo; /* might not be 1 */
> 
> Not only that, on DEC Alpha, even if CPU1's accesses are ordered, CPU2's
> accesses can be misordered.  You need rcu_dereference() or the combination
> of ACCESS_ONCE() and smp_read_barrier_depends() to avoid this issue.
> As always, see http://www.openvms.compaq.com/wizard/wiz_2637.html for
> more info.
> 
> So no, there is no guarantee.  I am assuming that the lock grabbed by
> CPU1 guards all assignments to "global", otherwise the code needs further
> help.  I am further assuming that the memory pointed to by CPU1's "p"
> is inaccessible to any other CPU, as in CPU1 just allocated the memory.
> Otherwise, the assignment "p->foo = 1" is questionable.  And finally,
> I am assuming that p->foo stays constant once it has been made
> accessible to readers.
> 
> But the following should work:
> 
> 	CPU1:
> 	  p->foo = 1;  /* Assumes p is local. */
> 	  smp_mb__before_spinlock();
> 	  grab lock
> 	  if (!global)  /* Assumes lock protects all assignments to global. */
> 	      global = p;
> 
> 	CPU2:
> 	  p = rcu_dereference(global);
> 	  if (p)
> 	     q = p->foo; /* Assumes p->foo constant once visible to readers. */
> 	     		 /* Also assumes p and q are local. */
> 
> If the assumptions called out in the comments do not hold, you at least
> need ACCESS_ONCE(), and perhaps even more synchronization.  For more info
> on ACCESS_ONCE(), Jon's LWN article is at http://lwn.net/Articles/508991/.

First of all, this "p->foo = 1" is a shorthand for initialization of
struct file done by opening a file.  What you are saying is that it
can leak past the point where we stick a pointer to freshly opened
file into a place where another CPU can see it, but not past the
barrier in dropping the lock, right?

And you are suggesting rcu_dereference() as a way to bring the required
barriers in.  Ouch...  The names are really bad, but there's another
fun issue - rcu_dereference brings in sparse noise.  Wouldn't direct use
of smp_read_barrier_depends() be cleaner, anyway?
