From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [RFC][PATCH 02/13] ovl: redirect dir by file handle on copy up
Date: Wed, 19 Apr 2017 17:16:15 +0200
Message-ID: <CAJfpegsiy9_-qmMhFRVq7L23WHq_f0HM4+gQQYeW06-3-guD8Q@mail.gmail.com>
References: <1492387183-18847-1-git-send-email-amir73il@gmail.com> <1492387183-18847-3-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:34533 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936962AbdDSPQW (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 19 Apr 2017 11:16:22 -0400
Received: by mail-io0-f193.google.com with SMTP id h41so4304701ioi.1
        for <linux-unionfs@vger.kernel.org>; Wed, 19 Apr 2017 08:16:22 -0700 (PDT)
In-Reply-To: <1492387183-18847-3-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org

On Mon, Apr 17, 2017 at 1:59 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> When mounted with mount option redirect_dir=fh,
> every copy up of lower directory stores the lower
> dir file handle in overlay.fh xattr of upper dir.

Is there a disadvantage to doing this unconditionally? (Same goes for patch 4)

Is there a disadvantage to doing this even for the non-samefs case?

Thanks,
Miklos
