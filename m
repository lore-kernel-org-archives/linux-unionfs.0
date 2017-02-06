From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: ovlfs: cannot read latest data from read only fd
Date: Mon, 6 Feb 2017 15:23:13 +0100
Message-ID: <CAJfpegsvvR9VUMLJMiR6h5nDVejs+fiucKzrHQX=yHH9x-p2DA@mail.gmail.com>
References: <f2adbe41-8896-ce9c-32e1-219c43e3f85a@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35240 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753404AbdBFOXO (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 6 Feb 2017 09:23:14 -0500
Received: by mail-oi0-f67.google.com with SMTP id x84so6574189oix.2
        for <linux-unionfs@vger.kernel.org>; Mon, 06 Feb 2017 06:23:14 -0800 (PST)
In-Reply-To: <f2adbe41-8896-ce9c-32e1-219c43e3f85a@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, miaoxie@huawei.com, yuchangchun1@huawei.com

On Mon, Feb 6, 2017 at 1:32 PM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> Hi:
> We found that we cannot read the latest data from an opened file(eg: "testfile") in overlayfs
> which was opened in read-only mode(this file was originally located in the lowerdir and
> mapped in the mergedir, and then was copied to upperdir when someone added some data later).
>
>         For example:
>
>         lower: testfile(empty)
>         upper: empty
>         work: empty
>         merge: empty
>
>         mount -t overlay -o lowerdir=lower,upperdir=upper,workdir=work overlayfs merge
>
>         1) fd1 = open("merge/testfile", O_RDONLY);
>         2) fd2 = open("merge/testfile", O_WRONLY | O_APPEND);
>            then we write some new data to fd2.
>         3) read data form fd1.
>
>         expect results: we read data which was written used by fd2.
>         reality results: nothing.
>
> We cannot read data from the copied file in the upperdir use fd1, so do we need to fix it?

This is a documented quirk (see section "Non-standard behavior" in
Documentation/filesystems/overlayfs.txt).

Hopefully will have a fix in a future version.

Thanks,
Miklos


>
> Thanks,
> zhangyi
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
