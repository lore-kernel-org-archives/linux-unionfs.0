From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2 3/5] ovl: generalize the lower_fs[] array
Date: Mon, 13 Jan 2020 15:30:10 +0100
Message-ID: <CAJfpegvqXAc2gH2zeAU3V+cNPujdT4h9gJ8f1m=NaAxUL5iXCw@mail.gmail.com>
References: <20191222080759.32035-1-amir73il@gmail.com> <20191222080759.32035-4-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-io1-f66.google.com ([209.85.166.66]:41379 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbgAMOaW (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 13 Jan 2020 09:30:22 -0500
Received: by mail-io1-f66.google.com with SMTP id c16so9980648ioo.8
        for <linux-unionfs@vger.kernel.org>; Mon, 13 Jan 2020 06:30:22 -0800 (PST)
In-Reply-To: <20191222080759.32035-4-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>

On Sun, Dec 22, 2019 at 9:08 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> Rename lower_fs[] array to fs[], extend its size by one and use
> index fsid (instead of fsid-1) to access the fs[] array.
>
> Initialize fs[0] with upper fs values. fsid 0 is reserved even with
> lower only overlay, so fs[0] remains null in this case.
>
> This gets rid of special casing upper layer in ovl_map_dev_ino().

Okay, but shouldn't this last one (which changes behavior) be split
into a separate patch?

Thanks,
Miklos
