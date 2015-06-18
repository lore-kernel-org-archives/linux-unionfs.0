From: Jan Olszak <j.olszak@samsung.com>
Subject: Optional switching off cow in overlayfs
Date: Thu, 18 Jun 2015 15:25:21 +0200
Message-ID: <5582C6C1.8080602@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:50359 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbbFRNZY (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 18 Jun 2015 09:25:24 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0NQ50082B6MADD30@mailout3.w1.samsung.com> for
 linux-unionfs@vger.kernel.org; Thu, 18 Jun 2015 14:25:22 +0100 (BST)
Received: from [106.116.147.212] by eusync3.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTPA id <0NQ500K2S6M9S5A0@eusync3.samsung.com> for
 linux-unionfs@vger.kernel.org; Thu, 18 Jun 2015 14:25:22 +0100 (BST)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org

Hi there!
I was wondering about a small improvement to overlayfs - optional, per 
file copy of write.

1. By default overlayfs would work as usual.
2. If a file in 'lower' filesystem has an xattr set (e.g. 
trusted.overlay.cow=n) the file would not be copied.

What do you think?

Cheers,
Jan
