From: sa <sa-dev@rainbow.by>
Subject: NFS lowerdir support in mainline kernel anytime soon?
Date: Tue, 19 May 2015 14:29:07 +0300
Message-ID: <555B1E83.7070106@rainbow.by>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mgate.rtcs.ru ([188.127.242.169]:57939 "EHLO mail.rainbow.by"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755802AbbESLeL (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 19 May 2015 07:34:11 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org

Hello!

Are there plans for NFS lowerdir in mainline kernel?


mount -t overlay overlay 
-olowerdir=/var.ro,upperdir=/tmp/.var.upperdir,workdir=/tmp/.var.workdir 
/tmp/.var.overlay

overlayfs: filesystem on '/var.ro' not supported

192.168.211.140:/sid/var on /var.ro type nfs 
(ro,relatime,vers=3,rsize=524288,wsize=524288,namlen=255,hard,nolock,proto=tcp,port=2049,timeo=7,retrans=10,sec=sys,local_lock=all,addr=192.168.211.140)

Linux sid 4.0.0-1-686-pae #1 SMP Debian 4.0.2-1 (2015-05-11) i686 GNU/Linux

-- 
sa
