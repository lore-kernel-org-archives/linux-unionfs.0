From: Alkis Georgopoulos <alkisg@gmail.com>
Subject: Overlay issue when truncating files over 2G
Date: Fri, 11 Sep 2015 11:05:06 +0300
Message-ID: <55F28B32.7000001@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:38785 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbbIKIFI (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 11 Sep 2015 04:05:08 -0400
Received: by wiclk2 with SMTP id lk2so48872866wic.1
        for <linux-unionfs@vger.kernel.org>; Fri, 11 Sep 2015 01:05:07 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: miklos@szeredi.hu
Cc: linux-unionfs@vger.kernel.org, djgroos@gmail.com

Hi, I think I've found an issue with overlay. Steps to reproduce:

# cd $(mktemp -d)
# mkdir lower upper work root
# truncate -s 3G lower/sparse
# mount -t overlay -o workdir=3Dwork,upperdir=3Dupper,lowerdir=3Dlower =
overlay=20
work
# truncate -s 0 work/sparse
truncate: cannot open =E2=80=98work/sparse=E2=80=99 for writing: Value =
too large for=20
defined data type

# umount work

My kernel is: 3.19.0-26-generic #28~14.04.1-Ubuntu SMP

Thanks,
Alkis Georgopoulos
