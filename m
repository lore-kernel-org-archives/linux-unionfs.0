From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [GIT PULL] overlay filesystem v25
Date: Tue, 28 Oct 2014 16:25:57 -0700
Message-ID: <20141028232557.GF5718@linux.vnet.ibm.com>
References: <20141025081845.GJ7996@ZenIV.linux.org.uk>
 <CAJfpegvM8d-cizf=3KmTSFVgAYPBDp_0fQAh+G2Q87u=taXm3A@mail.gmail.com>
 <20141025170609.GK7996@ZenIV.linux.org.uk>
 <CAJfpegucroRzo0NHTz=4N0WcrB2oDC0eDiZXk=aKSjc8vdYDjw@mail.gmail.com>
 <20141027155901.GE5718@linux.vnet.ibm.com>
 <20141027172800.GW7996@ZenIV.linux.org.uk>
 <20141027173621.GG5718@linux.vnet.ibm.com>
 <20141028011214.GZ7996@ZenIV.linux.org.uk>
 <20141028041127.GM5718@linux.vnet.ibm.com>
 <20141028225512.GD7996@ZenIV.linux.org.uk>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141028225512.GD7996@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Linus Torvalds <torvalds@linux-foundation.org>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Tue, Oct 28, 2014 at 10:55:13PM +0000, Al Viro wrote:
> On Mon, Oct 27, 2014 at 09:11:27PM -0700, Paul E. McKenney wrote:
> > On Tue, Oct 28, 2014 at 01:12:14AM +0000, Al Viro wrote:
> > > On Mon, Oct 27, 2014 at 10:36:21AM -0700, Paul E. McKenney wrote:
> > > > Code making direct use of smp_read_barrier_depends() is harder to read,
> > > > in my experience, but good point on the sparse noise.  Maybe a new
> > > > lockless_dereference() primitive?  Maybe something like the following?
> > > > (Untested, probably does not even build.)
> > > > 
> > > > #define lockless_dereference(p) \
> > > > ({ \
> > > > 	typeof(*p) *_________p1 = ACCESS_ONCE(p); \
> > > > 	smp_read_barrier_depends(); /* Dependency order vs. p above. */ \
> > > > 	_________p1; \
> > > > })
> > > 
> > > Hmm...  Where would you prefer to put it?  rcupdate.h?
> > 
> > Good a place as any, I guess.  Please see patch below.  Left to myself,
> > I would send this along for the next merge window, but please let me
> > know if you would like it sooner.
> 
> It's needed sooner, unfortunately.  Guys, could you take a look at
> vfs.git#for-linus and comment?

The version in your tree looks good.  I will drop my commit in favor
of yours.

The use of lockless_dereference() and smp_mb__before_spinlock() in
d45f00ae43 (overlayfs: barriers for opening upper-layer directory)
looks fine to me.  Only nit is lack of space between "=" and
lockless_dereference().

							Thanx, Paul
