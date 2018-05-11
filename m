Return-Path: <guaneryu@gmail.com>
Return-Path: <guaneryu@gmail.com>
Date: Fri, 11 May 2018 18:41:56 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH V2] xfstest: overlay: Add tests for overlay metadata only
 copy up feature
Message-ID: <20180511104156.GO8373@desktop>
References: <20180509152705.GA10101@redhat.com>
 <CAOQ4uxgRb0T6nWou7uasOF+QGEHRMa1C5wD4AsJABJDXK+yNhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgRb0T6nWou7uasOF+QGEHRMa1C5wD4AsJABJDXK+yNhQ@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, May 09, 2018 at 07:22:48PM +0300, Amir Goldstein wrote:
> On Wed, May 9, 2018 at 6:27 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > Hi,
> >
> > Please find attached the V2 of the patch. Took care of Amir's comments
> > from previous version.
> >
> > Add tests for metadata only copy up feature.
> >
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> 
> Looks good.
> 
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Thanks for the review!

> 
> Just a note to Eryu -
> 
> You may want to hold on to this test until metacopy is merged
> or at least staged on Miklos' next branch.

I'd wait for the patches hit Miklos' tree.

Thanks,
Eryu
