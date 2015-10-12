From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH RESEND 1/2] ovl: free stack of paths in ovl_fill_super
Date: Mon, 12 Oct 2015 17:22:18 +0200
Message-ID: <20151012152218.GB10697@tucsk>
References: <20150824125718.6218.9443.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:36299 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbbJLPUl (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 12 Oct 2015 11:20:41 -0400
Received: by wicgb1 with SMTP id gb1so153421691wic.1
        for <linux-unionfs@vger.kernel.org>; Mon, 12 Oct 2015 08:20:39 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20150824125718.6218.9443.stgit@buzz>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, linux-unionfs@vger.kernel.org

On Mon, Aug 24, 2015 at 03:57:18PM +0300, Konstantin Khlebnikov wrote:
> This fixes small memory leak after mount.

Both patches queued.

Thanks,
Miklos
