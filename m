From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [POC/RFC PATCH] overlayfs: constant inode numbers
Date: Mon, 5 Dec 2016 22:01:21 +0200
Message-ID: <CAOQ4uxj6kLW6VGfkm9h5KRi=LUnJ0tWH2rkSxagjbnCKD4+Lmg@mail.gmail.com>
References: <20161125212934.GB2622@veci.piliscsaba.szeredi.hu>
 <CAOQ4uxgSvo_v37aLJb8FK3c5sDqCkN2XWOd783UXaomdVAvsEQ@mail.gmail.com>
 <CAOQ4uxi2Ko-G2nA_bSWT8juuss9aS9ZfiBWS95RrdfBy30Tozg@mail.gmail.com>
 <CAOQ4uxjAODFk2L7d9P+br8wOY9NW5qKH3aaRC=umBfCGPeyxkg@mail.gmail.com>
 <CAJfpegvrRF7ZS+Shx6Q8L2BsbYpX3x3UEXkPn=3oEWs2zMP+eA@mail.gmail.com>
 <CAOQ4uxgSHah2OpbgW2nrDXjwXob=_ypjz9dbmHUO-1QrfwooXg@mail.gmail.com>
 <CAJfpeguTp4AwcnouMAse1=seG=LboW68eNfRjMiEpeaBjxuYQQ@mail.gmail.com>
 <CAOQ4uxhzRkPM6aOkksMsKU1V6tdsUxhObAD938PEUPKYPp6B5Q@mail.gmail.com>
 <CAOQ4uxj2yMwY_eCdc0+6U0QP1ckm5aPw5x6xtMz+WdHvJ4bFTg@mail.gmail.com>
 <CAJfpegtRNQAebLbz2F2zV8asqt31m7Lrgc+ya28UZU1e8E1oEw@mail.gmail.com> <CAOQ4uxjX=ewaCPjTUmvyynpZAwE1g_qf-+nE05zz5OFq99f+kw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wj0-f196.google.com ([209.85.210.196]:35074 "EHLO
        mail-wj0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751492AbcLEUBY (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 5 Dec 2016 15:01:24 -0500
In-Reply-To: <CAOQ4uxjX=ewaCPjTUmvyynpZAwE1g_qf-+nE05zz5OFq99f+kw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

[linux-kernel removed]

On Wed, Nov 30, 2016 at 5:05 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Tue, Nov 29, 2016 at 11:49 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
...
>
>> The following issues are left:
>>
>>  - performance of readdir;
>
> Here is one very simple optimization for WIP:
> @@ -157,6 +157,8 @@ static int ovl_fill_lowest(struct ovl_readdir_data *rdd,
>                 list_move_tail(&p->l_node, &rdd->middle);
>         } else {
>                 p = ovl_cache_entry_new(rdd, name, namelen, ino, d_type);
> +               if (p)
> +                       p->ino = ino;
>

Beyond that simple optimization, when file/dirs are created over whiteout,
we can mark the parent directory "remap_dino" and same when file/dir are
moved into a merged directory.

In every layer readdir would check "remap_dino" and if NOT set, it can skip
reading ino from xattr. All read entries would be marked as 'candidate ino'
and if another candidate of the same name is found in lower dir, it will update
p->ino.

>
>>  - hard link copy ups.
>>
>
> I'll start by setting up a TODO Wiki page and writing xfstests for all those

Wiki is up:
https://github.com/amir73il/overlayfs/wiki/Non-standard-behavior

Note that I have made the following observation about hard link copy up.
Not sure how much sense it makes:
"It is possible to imagine how solving the stable file handle goal could
be used to solve the broken hardlink issue - if there is a method to locate
a lower file handle that has been copied up by inode number/generation,
the same method can be used to check, when opening a lower file, if the
same inode has been already copied up for another alias".

Amir.
