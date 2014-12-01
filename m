From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: Cursor in readdir
Date: Mon, 1 Dec 2014 16:26:26 +0100
Message-ID: <CAJfpegt5vmDG-8=CoD1-FbHoMQFmFKvPELoU6OiUULoffkb-vQ@mail.gmail.com>
References: <54799BDC.5030201@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qa0-f50.google.com ([209.85.216.50]:50088 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215AbaLAP01 (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 1 Dec 2014 10:26:27 -0500
Received: by mail-qa0-f50.google.com with SMTP id w8so7249044qac.37
        for <linux-unionfs@vger.kernel.org>; Mon, 01 Dec 2014 07:26:26 -0800 (PST)
In-Reply-To: <54799BDC.5030201@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: hujianyang <hujianyang@huawei.com>
Cc: linux-unionfs@vger.kernel.org

On Sat, Nov 29, 2014 at 11:11 AM, hujianyang <hujianyang@huawei.com> wrote:
> Hi Miklos,
>
> Sorry for disturb you. I'm confused with *cursor* in struct
> ovl_dir_file. I know this struct ovl_cache_entry *cursor* is
> presented to indicate current pos when performing readdir at
> a MERGE type directory.
>
> Why this additional entry is needed? Can't we use a pointer
> to record which entry is read or is ready for reading? After
> finish reading lower and upper directories, entries in struct
> ovl_dir_cache is stabilized. Changing of directories will
> cause the later .readdir() to create a new ovl_dir_cache but
> the old cache will not be released until all the holders of
> it call .release().
>
> So I think a pointer points to an entry in the entry list of
> ovl_dir_cache is enough to each process sharing the access
> of the same cache. We don't need to keep and move an special
> entry, *cursor*. That's my thought.

Cursors are safe against removal of current entry.   However, we don't
do that here, AFAICS, so I think you are correct in that the cursor is
not actually needed here.

Thanks,
Miklos
