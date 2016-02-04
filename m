From: Nikolay Borisov <n.borisov@siteground.com>
Subject: Re: Problem writing to ovl with CIFS as lower dir
Date: Thu, 4 Feb 2016 19:28:23 +0200
Message-ID: <CAJFSNy7gY6fT1iRyK7TnUPUx_3VWoHxXoBGf_-6Odb14Eyk=Ow@mail.gmail.com>
References: <56B37622.40604@kyup.com>
	<16233.1454602273@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:36671 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934526AbcBDR2Y (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 4 Feb 2016 12:28:24 -0500
Received: by mail-oi0-f50.google.com with SMTP id x21so19814963oix.3
        for <linux-unionfs@vger.kernel.org>; Thu, 04 Feb 2016 09:28:23 -0800 (PST)
In-Reply-To: <16233.1454602273@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Nikolay Borisov <kernel@kyup.com>, Miklos Szeredi <miklos@szeredi.hu>, SiteGround Operations <operations@siteground.com>, linux-unionfs@vger.kernel.org

On Thu, Feb 4, 2016 at 6:11 PM, David Howells <dhowells@redhat.com> wrote:
> Ummm...  I wouldn't've thought that CIFS was allowed as the lower dir since it
> supports case-independent filenames.

Well, since the ovl_is_allowed_fs_type was removed I guess there is no
limitation as to what networked fs you could mount. But in any case, that's why
I also tested with NFS and also got the same result.

>
> David
