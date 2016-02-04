From: Nikolay Borisov <kernel@kyup.com>
Subject: Problem writing to ovl with CIFS as lower dir
Date: Thu, 4 Feb 2016 18:02:42 +0200
Message-ID: <56B37622.40604@kyup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:34227 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144AbcBDQCq (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 4 Feb 2016 11:02:46 -0500
Received: by mail-wm0-f43.google.com with SMTP id 128so33847431wmz.1
        for <linux-unionfs@vger.kernel.org>; Thu, 04 Feb 2016 08:02:45 -0800 (PST)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: SiteGround Operations <operations@siteground.com>, linux-unionfs@vger.kernel.org

Hello,

[I'm not subscribed to the list please CC me when replying]

I'm testing overlayfs on 3.12 (own-made port) and on 4.4 (to confirm
behavior) and what I observe is that when I try to write to a file in
the merge directory e.g:

echo "test" > merged/test-file1

I get -EINVAL on 3.12 and -ENXIO on 4.4. However, when I try to touch a
file in the merged directory I have no issues. This happens only when
the lower mount is either CIFS/NFS. When it's another ext4 directory I
have no problems whatsoever. Is this behavior expected, I'm willing to
assume I've screwed up the 3.12 port but given that I see this on 4.4
(no custom modifications) I'm beginning to think this is innate into the
the design?

Regards,
Nikolay
