From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 13/13] ovl: Enable metadata only feature
Date: Thu, 26 Oct 2017 14:19:33 -0400
Message-ID: <20171026181933.GF28005@redhat.com>
References: <1508958575-14086-1-git-send-email-vgoyal@redhat.com>
 <1508958575-14086-14-git-send-email-vgoyal@redhat.com>
 <CAOQ4uxgN0qdgGAV2fcYHL7rZtb7W-H2zEmP0QAzNNEcxKz6bLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42214 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932275AbdJZSTe (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 26 Oct 2017 14:19:34 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgN0qdgGAV2fcYHL7rZtb7W-H2zEmP0QAzNNEcxKz6bLQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Thu, Oct 26, 2017 at 10:07:39AM +0300, Amir Goldstein wrote:
> On Wed, Oct 25, 2017 at 10:09 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > All the bits are in patches before this. So it is time to enable the
> > metadata only copy up feature.
> >
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  fs/overlayfs/copy_up.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> > index 4876ae4..3ce35e1 100644
> > --- a/fs/overlayfs/copy_up.c
> > +++ b/fs/overlayfs/copy_up.c
> > @@ -637,12 +637,13 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
> >         int err;
> >         DEFINE_DELAYED_CALL(done);
> >         struct path parentpath;
> > +       struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
> >         struct ovl_copy_up_ctx ctx = {
> >                 .parent = parent,
> >                 .dentry = dentry,
> >                 .workdir = ovl_workdir(dentry),
> >                 .origin = true,
> > -               .metacopy = false,
> > +               .metacopy = ofs->config.metacopy,
> 
> This should have been better
> .metacopy = ovl_dentry_needs_data_copy_up(dentry)

You mean ovl_dentry_needs_meta_copy_up(). Ok, I will introduce a
helper for this and get rid of other code.

> to begin with and the helper would start with
> 
> if (true) return; (with a TODO comment)
> 
> That this patch would fix to
> if (!ofs->config.metacopy) return
> 
> Then you don't need to check ISREG and write flags below.

Will do.

Vivek
