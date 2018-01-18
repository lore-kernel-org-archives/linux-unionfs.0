From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [ANNOUNCE PATCH v4 0/5] overlay: implement fsck.overlay utility
Date: Thu, 18 Jan 2018 09:34:59 +0200
Message-ID: <CAOQ4uxgjhCd2NnazMLgvUGV18VQUjw_E_GLZApY1YuuNAn+DEQ@mail.gmail.com>
References: <20180118035056.17358-1-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20180118035056.17358-1-yi.zhang@huawei.com>
Sender: fstests-owner@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Eryu Guan <eguan@redhat.com>, Miao Xie <miaoxie@huawei.com>, yangerkun@huawei.com, "zhangyi (F)" <yizhang089@gmail.com>
List-Id: linux-unionfs@vger.kernel.org

On Thu, Jan 18, 2018 at 5:50 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> Hi All,
>
> Here is the forth version of fsck.overlay. Most of comments from last
> three iterations have been handled. Now, this tool have three basic
> features (see README for detail, include TODO list):
> 1. Check and fix orphan whiteouts,
> 2. Check and fix invalid/duplicate redirect directories,
> 3. Check and fix missing impure xattrs.
>
> This incubation tool will post to github repository[1] directly.
> Any suggestion is helpful if you review the source code or find
> bugs/improvements when you use/test this tool.
>
> Thanks,
> Yi.
>
> [1] https://github.com/hisilicon/overlayfs-progs

Very nice work!
I find your code very pleasant to read.
I did not go through it all to check functional correctness.
Just have some minor high level comments.
In general, many functions could use a comment and more
files could use a header comment.

>
> Changes since v3:
> - Use existing library for path manipulation and separate
>   self-implemented manipulation helpers. (Comment from Amir)

Specifically, in what way in basename2() different than basename()?
and what is a the semantics of joinname()?
There are thing better documented above the functions, especially
for general utility functions.


> - Use fstatat() with relative path instead of lstat() with absolute path
>   when traverse layers and lookup target. (Amir)
> - Split check routines into two pass, the first pass check redirect dir
>   to confirm directory structure, the second pass check whiteouts and
>   impure xattr.

This could be an opportunity to start splitting check.c which is getting
bigger to pass1.c pass2.c or to check_whiteout.c check_redirect.c.
I leave it up to you to decide when and how to split.

> - Change list to linux kernel style.

This is a good example of code copied/derived from kernel code
that is placed in a dedicated file with header comment to state
this fact.

You should do the same with other functions that are copied from
kernel and place them in a dedicated file with header comment.
There are 2 such helpers in mount.c and at least one constant in
config.h.


> - Fix duplicate redirect xattr check, correct questions and default
>   actions, and handle cases of duplicate redirect xattr in different
>   layers. (Amir)
> - Fix impure xattr comments and invalid error message. (Amir & Vivek)
>
> ----------------
>
> Changes since v2(v1):
>
> - Add "-n -p -y" options. (Comment from Amir and Darrick)
> - Change underlying dirs input to '-o' option like mount(8). (Miklos)
> - Remove invalid opaque check. (Miklos)
> - Correct redirect xattr check. (Amir and Miklos)
> - Fix lower target lookup, handle the missing case of opaque and
>   redirect parent.
> - Add impure xattr check. (Amir)
>
> zhangyi (F) (5):
>   overlay: implement fsck utility
>   fsck.overlay: correct redirect xattr check
>   fsck.overlay: add origin count
>   fsck.overlay: add merge and redirect subdir count
>   fsck.overlay: add impure xattr check
>
