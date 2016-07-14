From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] ovl: fix link error without POSIX ACL
Date: Thu, 14 Jul 2016 14:16:01 +0200
Message-ID: <CAJfpegtdGL1+ZeEUbLHgdQjQUWprYM=OqsZyU+sLsJp-vftPyQ@mail.gmail.com>
References: <20160714095512.768359-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:36090 "EHLO
	mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbcGNMQD (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 14 Jul 2016 08:16:03 -0400
Received: by mail-oi0-f68.google.com with SMTP id u68so6642227oie.3
        for <linux-unionfs@vger.kernel.org>; Thu, 14 Jul 2016 05:16:02 -0700 (PDT)
In-Reply-To: <20160714095512.768359-1-arnd@arndb.de>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Vivek Goyal <vgoyal@redhat.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-kernel@vger.kernel.org

On Thu, Jul 14, 2016 at 11:54 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> The latest fix for ACL on overlayfs introduced a link error:
>
> fs/built-in.o: In function `ovl_posix_acl_xattr_set':
> file.c:(.text+0x6b320): undefined reference to `posix_acl_from_xattr'
>
> posix_acl_from_xattr doesn't have a 'static inline' implementation when
> CONFIG_FS_POSIX_ACL is disabled, and I could not come up with an obvious
> way to do it.
>
> This instead avoids the link error by defining two sets of ACL operations
> and letting the compiler drop one of the two at compile time depending
> on CONFIG_FS_POSIX_ACL. This avoids all references to the ACL code,
> also leading to smaller code.

Thanks, pushed.

Miklos
