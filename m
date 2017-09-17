From: Dave Chinner <david@fromorbit.com>
Subject: Re: [GIT PULL] overlayfs update for 4.14
Date: Mon, 18 Sep 2017 07:27:05 +1000
Message-ID: <20170917212705.GB17782@dastard>
References: <20170913140528.GA19278@veci.piliscsaba.szeredi.hu>
 <CA+55aFzgQWNMc8Mx1SvCxt53wWJc67qB0uo95=VC1eivmG=YxA@mail.gmail.com>
 <CAJfpegtYjNyW1HnF2PAdmRWB4nq3eTF9O5-H2tnztZhagVW+Uw@mail.gmail.com>
 <CA+55aFzzKg17=RYTUomF9Fsy0mM5Acqkak0EZJPivZ5+oZErwA@mail.gmail.com>
 <CAJfpegvK_LyL0eHbmpp=NrJMnS1i8KkPpxRtBL_zyB_n-NKg7A@mail.gmail.com>
 <CA+55aFznd3O7CtT9tKSs4_HVY_OYiUHdcZFzx8eQaG8Ye5AVdA@mail.gmail.com>
 <20170915073226.GC19278@veci.piliscsaba.szeredi.hu>
 <CAJfpeguB=H=FNyMDyyO4417o1DSiw-5RS0S3nzENHiCRiqmYRQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJfpeguB=H=FNyMDyyO4417o1DSiw-5RS0S3nzENHiCRiqmYRQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Fri, Sep 15, 2017 at 10:06:24AM +0200, Miklos Szeredi wrote:
> or some way to have a shared page
> cache that's breakable on copy up, which does not look trivial at all.

If we get that, it will come through overlay using reflink for
copyup and filesystems doing the page cache sharing of multiply
referenced data blocks. I don't see overlay being involved in this
functionality at all....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
