From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 13/13] ovl: Enable metadata only feature
Date: Thu, 26 Oct 2017 10:07:39 +0300
Message-ID: <CAOQ4uxgN0qdgGAV2fcYHL7rZtb7W-H2zEmP0QAzNNEcxKz6bLQ@mail.gmail.com>
References: <1508958575-14086-1-git-send-email-vgoyal@redhat.com> <1508958575-14086-14-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:45337 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750997AbdJZHHk (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 26 Oct 2017 03:07:40 -0400
Received: by mail-yw0-f193.google.com with SMTP id j4so2113702ywb.2
        for <linux-unionfs@vger.kernel.org>; Thu, 26 Oct 2017 00:07:40 -0700 (PDT)
In-Reply-To: <1508958575-14086-14-git-send-email-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Wed, Oct 25, 2017 at 10:09 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> All the bits are in patches before this. So it is time to enable the
> metadata only copy up feature.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/overlayfs/copy_up.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index 4876ae4..3ce35e1 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -637,12 +637,13 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
>         int err;
>         DEFINE_DELAYED_CALL(done);
>         struct path parentpath;
> +       struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
>         struct ovl_copy_up_ctx ctx = {
>                 .parent = parent,
>                 .dentry = dentry,
>                 .workdir = ovl_workdir(dentry),
>                 .origin = true,
> -               .metacopy = false,
> +               .metacopy = ofs->config.metacopy,

This should have been better
.metacopy = ovl_dentry_needs_data_copy_up(dentry)
to begin with and the helper would start with

if (true) return; (with a TODO comment)

That this patch would fix to
if (!ofs->config.metacopy) return

Then you don't need to check ISREG and write flags below.
