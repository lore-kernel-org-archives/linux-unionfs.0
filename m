From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v11 00/18] overlayfs: Delayed copy up of data
Date: Thu, 1 Feb 2018 01:41:23 +0200
Message-ID: <CAOQ4uxjRbhGHvVOTTN8z-iCV=vQki97x+5LWQB2xXHn+tirJ8A@mail.gmail.com>
References: <20180131211329.16328-1-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f173.google.com ([209.85.161.173]:40943 "EHLO
        mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752479AbeAaXlY (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 31 Jan 2018 18:41:24 -0500
Received: by mail-yw0-f173.google.com with SMTP id j128so9005480ywg.7
        for <linux-unionfs@vger.kernel.org>; Wed, 31 Jan 2018 15:41:24 -0800 (PST)
In-Reply-To: <20180131211329.16328-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, "zhangyi (F)" <yi.zhang@huawei.com>

On Wed, Jan 31, 2018 at 11:13 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Hi,
>
> Please find attached V11 of patches. Looks like now new design might
> change these patches significantly based on Miklos's feedback. So I
> am posting my latest patches based on current design. Just in case we
> decide that we want to stick to old design.
>
> Change from V10:
>
> - Based on Amir's feedback, I am not storing the full origin chain in
>   lowerstack now. Instead now I am storing only two dentries at max in
>   lowerstack. lowerstack[0] will point to top most metacopy dentry in
>   lower and lowerstack[1] will have data dentry.
>

BTW, this is not contrary to Miklos's "big unifying theory".
In theory, directories could also be METACOPY when copied up
for metadata operations and become real copy ups when they
get the first child entry.

If METACOPY directories existed in middle layers, we could also
eliminate them from the stack. In fact, we could have eliminated
empty dirs from the stack if we had a quick way of knowing that
a dir is empty.

Cheers,
Amir.
