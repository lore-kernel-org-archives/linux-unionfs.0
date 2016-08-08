From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] ovl: fix copy up opaque directory
Date: Mon, 8 Aug 2016 15:21:57 +0200
Message-ID: <CAJfpegugp-t55NU5L8qRA2Fc0a7ttraqkYQgoHp7FosiE7f52w@mail.gmail.com>
References: <1470337477-7297-1-git-send-email-dmcg@drizz.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:36261 "EHLO
	mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbcHHNV6 (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 8 Aug 2016 09:21:58 -0400
Received: by mail-oi0-f66.google.com with SMTP id a101so5342994oic.3
        for <linux-unionfs@vger.kernel.org>; Mon, 08 Aug 2016 06:21:58 -0700 (PDT)
In-Reply-To: <1470337477-7297-1-git-send-email-dmcg@drizz.net>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Derek McGowan <dmcg@drizz.net>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Thu, Aug 4, 2016 at 9:04 PM, Derek McGowan <dmcg@drizz.net> wrote:
> When a copy up of a directory occurs which has the opaque xattr set, the
> xattr remains in the upper directory. The immediate behavior with overlayfs
> is that the upper directory is not treated as opaque, however after a
> remount the opaque flag is used and upper directory is treated as opaque.
> This causes files created in the lower layer to be hidden when using
> multiple lower directories. This change fixes the behavior to remove the
> opaque flag when an opaque directory is copied up.

Thanks for the report.

I redid the patch to instead of "copy + check + remove" the xattr it
simply doesn't copy.

Updated patch pushed to:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git for-linus

Thanks,
Miklos
