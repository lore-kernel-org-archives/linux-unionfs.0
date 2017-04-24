From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 04/11] ovl: store file handle of lower inode on copy up
Date: Mon, 24 Apr 2017 16:57:13 +0300
Message-ID: <CAOQ4uxi98NobOt3wck2_ona-dsS6OMJSHr+iDANVHi0vkge=oQ@mail.gmail.com>
References: <1493025256-27188-5-git-send-email-amir73il@gmail.com> <201704242153.XQhZVb57%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:35900 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1171420AbdDXN5P (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 24 Apr 2017 09:57:15 -0400
In-Reply-To: <201704242153.XQhZVb57%fengguang.wu@intel.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, Miklos Szeredi <miklos@szeredi.hu>, Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Mon, Apr 24, 2017 at 4:32 PM, kbuild test robot <lkp@intel.com> wrote:
> Hi Amir,
>
> [auto build test WARNING on miklos-vfs/overlayfs-next]
> [also build test WARNING on v4.11-rc8 next-20170424]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>
> url:    https://github.com/0day-ci/linux/commits/Amir-Goldstein/overlayfs-constant-inode-numbers/20170424-175555
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-next
>
>
> coccinelle warnings: (new ones prefixed by >>)
>
>>> fs/overlayfs/copy_up.c:309:7-14: ERROR: PTR_ERR applied after initialization to constant on line 299

Why is this wrong?
The pointer tested is not const - it's referenced data is.

Anyway, this pointed out another thing worth a warning:
The static variable null_fh was meant to be const.
I wonder if coccinelle has a way to figure out this pattern?
I guess not.

> > 289 static struct ovl_fh null_fh = {
>   290    .version = OVL_FH_VERSION,
>   291    .magic = OVL_FH_MAGIC,
>   292    .type = FILEID_INVALID,

>
> vim +309 fs/overlayfs/copy_up.c
>

>    293          .len = sizeof(struct ovl_fh),
>    294  };
>    295
>    296  static int ovl_set_lower_fh(struct dentry *dentry, struct dentry *upper)
>    297  {
>    298          int err;
>  > 299          const struct ovl_fh *fh = NULL;
>    300
>    301          if (ovl_redirect_fh(dentry->d_sb))
>    302                  fh = ovl_get_fh(ovl_dentry_lower(dentry));
>    303          /*
>    304           * On failure to encode lower fh, store an invalid 'null' fh, so
>    305           * we can always use the overlay.fh xattr to distignuish between
>    306           * a copy up and a pure upper inode.  If lower fs does not support
>    307           * encoding fh, don't try to encode again.
>    308           */
>  > 309          err = PTR_ERR(fh);
>    310          if (IS_ERR_OR_NULL(fh)) {
>    311                  if (err == -EOPNOTSUPP) {
>    312                          pr_warn("overlay: file handle not supported by lower - turning off redirect_fh\n");
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
