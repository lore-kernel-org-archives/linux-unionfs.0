From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] overlayfs: use a minimal buffer in ovl_copy_xattr
Date: Tue, 10 Nov 2015 17:12:16 +0100
Message-ID: <CAJfpegtR8WBSG33YdB=psrcccCG52DK1eFZD9i9XtQJ13y5umw@mail.gmail.com>
References: <CAKp8XJ4QYqdJEevtnb_KRPfCqTT5Hq_jhppnaqdvLtycA2fAyw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:33706 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967AbbKJQMR (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 10 Nov 2015 11:12:17 -0500
Received: by obbww6 with SMTP id ww6so1127612obb.0
        for <linux-unionfs@vger.kernel.org>; Tue, 10 Nov 2015 08:12:17 -0800 (PST)
In-Reply-To: <CAKp8XJ4QYqdJEevtnb_KRPfCqTT5Hq_jhppnaqdvLtycA2fAyw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vito Caputo <vito.caputo@coreos.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Thu, Oct 22, 2015 at 12:41 AM, Vito Caputo <vito.caputo@coreos.com> wrote:
> Greetings,
>
> We've been receiving reports of ooms triggered by the high-order allocation
> in the overlayfs ovl_copy_xattr() implementation.
>
> The bug is in the handling of direct-reclaim high-order allocations (and
> appears to be known and actively being worked on).  Rather than do something
> hacky in mm and potentially destabilize everything for a quick fix, I've put
> together a simple patch changing the allocation to an as-needed krealloc()
> approach which should eliminate the ooms, since 64KiB extended attributes
> are uncommon.

Thanks.  Pushed to

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-next

Miklos
