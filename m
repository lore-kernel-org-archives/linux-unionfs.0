From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] ovl: fix return value of ovl_fill_super
Date: Tue, 6 Dec 2016 11:27:19 +0100
Message-ID: <CAJfpegu21pRPKdbmDg0GLHCx+OOLSdBVxT=+csdVE-ieoH9udQ@mail.gmail.com>
References: <94af12abde2c71fe42b4ba340cf93faaed4909e7.1479481211.git.geliangtang@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:36433 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751852AbcLFK1U (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 6 Dec 2016 05:27:20 -0500
Received: by mail-oi0-f66.google.com with SMTP id u15so40511253oie.3
        for <linux-unionfs@vger.kernel.org>; Tue, 06 Dec 2016 02:27:20 -0800 (PST)
In-Reply-To: <94af12abde2c71fe42b4ba340cf93faaed4909e7.1479481211.git.geliangtang@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Geliang Tang <geliangtang@gmail.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-kernel@vger.kernel.org

On Fri, Nov 18, 2016 at 4:02 PM, Geliang Tang <geliangtang@gmail.com> wrote:
> If kcalloc() failed, the return value of ovl_fill_super() is -EINVAL,
> not -ENOMEM. So this patch sets this value to -ENOMEM before calling
> kcalloc(), and sets it back to -EINVAL after calling kcalloc().

Thanks, applied.

Miklos
