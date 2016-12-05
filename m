From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [RFC][PATCH 3/4] ovl: fold ovl_copy_up_truncate() into ovl_copy_up()
Date: Mon, 5 Dec 2016 15:51:07 +0100
Message-ID: <CAJfpegt897XLi3sO8V61jybbkz0w=oAdvAAyxeQvHg3zpATL7w@mail.gmail.com>
References: <1478979364-10355-1-git-send-email-amir73il@gmail.com> <1478979364-10355-4-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:35881 "EHLO
        mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751127AbcLEOv1 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 5 Dec 2016 09:51:27 -0500
Received: by mail-oi0-f50.google.com with SMTP id v84so340556125oie.3
        for <linux-unionfs@vger.kernel.org>; Mon, 05 Dec 2016 06:51:08 -0800 (PST)
In-Reply-To: <1478979364-10355-4-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org

On Sat, Nov 12, 2016 at 8:36 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> This removes code duplication and is prep work
> for fixing up copy up locking.

Thanks, applied.

Miklos
