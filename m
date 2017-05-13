From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ovl: Select EXPORTFS for exportfs_{en,de}code_fh
Date: Sat, 13 May 2017 09:37:58 +0300
Message-ID: <CAOQ4uxiGTTr5qtp9HVH2ri2sH3bhOkP+avnwM+fwyU5xKKe5mA@mail.gmail.com>
References: <20170513021757.2356-1-f.fainelli@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:34452 "EHLO
        mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750944AbdEMGh7 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 13 May 2017 02:37:59 -0400
In-Reply-To: <20170513021757.2356-1-f.fainelli@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, "open list:OVERLAY FILESYSTEM" <linux-unionfs@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>

On Sat, May 13, 2017 at 5:17 AM, Florian Fainelli <f.fainelli@gmail.com> wrote:
> fs/overlayfs/namei.c now calls exportfs_decode_fh() and
> fs/overlayfs/copy_up.c calls exportfs_encode_fh() but misses an EXPORTFS
> select which results in the following build error:
>

Arnd has already sent that patch 2 days ago, but Thanks!
