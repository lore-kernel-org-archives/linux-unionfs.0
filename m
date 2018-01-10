From: Chengguang Xu <cgxu519@icloud.com>
Subject: information of statfs
Date: Wed, 10 Jan 2018 14:17:29 +0800
Message-ID: <6ABBC786-3164-4A8A-A7B8-6BE7F91E8DFD@icloud.com>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from pv33p36im-asmtp001.me.com ([17.142.213.62]:48864 "EHLO
        pv33p36im-asmtp001.me.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753014AbeAJGRf (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 10 Jan 2018 01:17:35 -0500
Received: from process-dkim-sign-daemon.pv33p36im-asmtp001.me.com by
 pv33p36im-asmtp001.me.com
 (Oracle Communications Messaging Server 8.0.1.2.20170607 64bit (built Jun  7
 2017)) id <0P2B00G00TGR2100@pv33p36im-asmtp001.me.com> for
 linux-unionfs@vger.kernel.org; Wed, 10 Jan 2018 06:17:34 +0000 (GMT)
Received: from icloud.com ([127.0.0.1]) by pv33p36im-asmtp001.me.com
 (Oracle Communications Messaging Server 8.0.1.2.20170607 64bit (built Jun  7
 2017)) with ESMTPSA id <0P2B008AZTH5ET30@pv33p36im-asmtp001.me.com> for
 linux-unionfs@vger.kernel.org; Wed, 10 Jan 2018 06:17:33 +0000 (GMT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: overlayfs <linux-unionfs@vger.kernel.org>

Hello,

This is just my suggestion, in ovl_statfs() isn=A1=AFt it better to set
below fields(indicating available free resource) to zero when overlayfs
doesn=A1=AFt have upper fs=A3=BFBecause overlayfs can not occupy =
resource in
lower stack fs anymore, I think it can reduce the possibility of
misunderstanding from caller.

u64 f_bfree  /* free blocks in fs */
u64 f_bavail /* free blocks available to unprivileged user */
u64 f_ffree  /* free file nodes in fs */


Thanks,
Chengguang.
