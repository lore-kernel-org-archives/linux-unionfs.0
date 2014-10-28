From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [GIT PULL] overlay filesystem v25
Date: Tue, 28 Oct 2014 01:12:14 +0000
Message-ID: <20141028011214.GZ7996@ZenIV.linux.org.uk>
References: <20141024022055.GH7996@ZenIV.linux.org.uk>
 <20141024032422.GI7996@ZenIV.linux.org.uk>
 <CAJfpegt-X_Cd8B5H65keshhhuwH2-HPpaBC30atKeS3QjaariA@mail.gmail.com>
 <20141025081845.GJ7996@ZenIV.linux.org.uk>
 <CAJfpegvM8d-cizf=3KmTSFVgAYPBDp_0fQAh+G2Q87u=taXm3A@mail.gmail.com>
 <20141025170609.GK7996@ZenIV.linux.org.uk>
 <CAJfpegucroRzo0NHTz=4N0WcrB2oDC0eDiZXk=aKSjc8vdYDjw@mail.gmail.com>
 <20141027155901.GE5718@linux.vnet.ibm.com>
 <20141027172800.GW7996@ZenIV.linux.org.uk>
 <20141027173621.GG5718@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:45190 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbaJ1BMR (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 27 Oct 2014 21:12:17 -0400
Content-Disposition: inline
In-Reply-To: <20141027173621.GG5718@linux.vnet.ibm.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Linus Torvalds <torvalds@linux-foundation.org>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-unionfs@vger.kernel.org

On Mon, Oct 27, 2014 at 10:36:21AM -0700, Paul E. McKenney wrote:
> Code making direct use of smp_read_barrier_depends() is harder to read,
> in my experience, but good point on the sparse noise.  Maybe a new
> lockless_dereference() primitive?  Maybe something like the following?
> (Untested, probably does not even build.)
> 
> #define lockless_dereference(p) \
> ({ \
> 	typeof(*p) *_________p1 = ACCESS_ONCE(p); \
> 	smp_read_barrier_depends(); /* Dependency order vs. p above. */ \
> 	_________p1; \
> })

Hmm...  Where would you prefer to put it?  rcupdate.h?
