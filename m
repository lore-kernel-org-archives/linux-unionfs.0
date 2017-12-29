From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v3 1/6] overlay: implement fsck utility
Date: Fri, 29 Dec 2017 11:20:09 +0200
Message-ID: <CAOQ4uxhh5XV7Uu6J+Xdzs8JcgJ5=-T=tGAKXvaJ=vx9SdUJ3eA@mail.gmail.com>
References: <20171228114023.43999-1-yi.zhang@huawei.com> <20171228114023.43999-2-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20171228114023.43999-2-yi.zhang@huawei.com>
Sender: fstests-owner@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Eryu Guan <eguan@redhat.com>, Miao Xie <miaoxie@huawei.com>, yangerkun@huawei.com
List-Id: linux-unionfs@vger.kernel.org

On Thu, Dec 28, 2017 at 1:40 PM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> fsck.overlay
> ============
>
> fsck.overlay is used to check and optionally repair underlying
> directories of overlay-filesystem.
>
> Check the following points:
>
> Whiteouts
> ---------
>
> A whiteout is a character device with 0/0 device number. It is used to
> record the removed files or directories, When a whiteout is found in a
> directory, there should be at least one directory or file with the
> same name in any of the corresponding lower layers. If not exist, the
> whiteout will be treated as orphan whiteout and remove.
>
> Redirect directories
> --------------------
>
> An redirect directory is a directory with "trusted.overlay.redirect"
> xattr valued to the path of the original location from the root of
> the overlay. It is only used when renaming a directory and "redirect
> dir" feature is enabled.
> If an redirect directory is found, the following must be met:
>
> 1) The directory path pointed by redirect xattr should exist in one of
>    lower layers.
> 2) The origin directory should be redirected only once in one layer,

"in one layer" - how about:
mkdir lower2/origin
make_redirect lower/test1 origin
make_redirect upper/test2 origin

Two redirects to the same lower(2) dir from two different layers

Zhangyi,

This patch is a little big for me to review properly, so you have a few options:
1. break it up to reviewable chunks, starting with minimal skeleton and adding
functionality slowly in chewable chunks
2. wait for other reviewers to review it as is
3. push the code to your repository and announce 0.1-alpha without Reviewed-by
approval and get the approval on the tool from testers and users

I do have one high level comments about the path string parsing/manipulation
code - I think it would be better if you could use an existing library for that.
I cannot recommend any, but I assume that there are options. At the very leasy
you could maybe use the dirname(3)/basename(3) libgen functions.
Even if you do end up implementing all path manipulation helpers, please keep
them well separated and with well defined API, so that they could be split to
a library down the road.

Also, I see that you still use lstat() and not  fstatat() relative to
fd of root layer.
Is that because of the file descriptor limit problem? another reason?
I am returning to that point because it seem to me that fsck.overlay shouldn't
be bothered by the symlinks or whatnot that are parents of the layers root.
Overlayfs isn't bothered with those. Layer lookup always starts from layer root.
FWIW, I don't think that requiring more resources than usual (file descriptors)
is too much to ask when running fsck.overlay of many layers - only it need to
be documented.
For comparison, e2fsck takes a LOT of resources when there are lots of
hardlinks, just not file descriptors.

Cheers,
Amir.
