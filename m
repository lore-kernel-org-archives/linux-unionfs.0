From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: Cursor in readdir
Date: Fri, 5 Dec 2014 11:50:39 +0100
Message-ID: <CAJfpegvhvVRLO9J5R6MkgM-hqyUDD4Gq0EV9-y5FqQWObzHKiQ@mail.gmail.com>
References: <54799BDC.5030201@huawei.com>
	<CAJfpegt5vmDG-8=CoD1-FbHoMQFmFKvPELoU6OiUULoffkb-vQ@mail.gmail.com>
	<54817F19.4010609@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qa0-f48.google.com ([209.85.216.48]:48257 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbaLEKuk (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 5 Dec 2014 05:50:40 -0500
Received: by mail-qa0-f48.google.com with SMTP id v10so231651qac.7
        for <linux-unionfs@vger.kernel.org>; Fri, 05 Dec 2014 02:50:40 -0800 (PST)
In-Reply-To: <54817F19.4010609@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: hujianyang <hujianyang@huawei.com>
Cc: linux-unionfs@vger.kernel.org

On Fri, Dec 5, 2014 at 10:47 AM, hujianyang <hujianyang@huawei.com> wrote:
> On 2014/12/1 23:26, Miklos Szeredi wrote:
>
> Do you think it's valuable to discard the using of *cursor* and
> use a pointer instead? Or maybe we will enable some remove
> operations for ovl_dir_cache in the future so we should keep
> this mechanism.

Will probably need to do remove operations on merged layers as
whiteouts anyway, which does not involve actual removal of entry.  So
I guess the cursor won't be needed.

> What's your opinion? I'd like to change this part and see if
> the usage of a pointer could speed up .readdir() on a merged
> directory.

If it's a cleanup (removes more complexity than it adds) then a patch
is welcome.

Thanks,
Miklos
