Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A91D2765C1
	for <linux-unionfs@vger.kernel.org>; Mon, 18 Aug 2025 10:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755513666; cv=none; b=GCrzR1PD9eXtfzpld9T66o1LjI3iNHxX6Svqd7484E49w45junvVM5ootlfpqwzAsDV2rKiK6zSOafBmTG5iNwyg45gDE7dXKHbWqWu+uxNxXMWrtlHEZEjGmx4Sz/ppzj9D0ZHe7kVuBDkTSXBdIsOE/WWgMA5dq8f8U54t8AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755513666; c=relaxed/simple;
	bh=Mqo3UGE1Bme+tAtLCwb1TjVSd0SAvNdv83hNNSqLSRo=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=RRQoPeXywtZI7Q8YyA5YYzEFlgwamaHMfe6fzu/7kWLfgIrSImxlq8lAdpSnVJYF6bfs7W3uw4MWU/Wup3I3+rnv4TAEDomZ8JRaqQHV8p+f7QeZk5+ktcM6L75/mB+ZYEa30PRtcgLT9EvkN4gVrGTMGNEdkjVIg9ou+MDpXvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3e66b7e4a94so29903645ab.1
        for <linux-unionfs@vger.kernel.org>; Mon, 18 Aug 2025 03:41:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755513663; x=1756118463;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NrG4Vx3qtfYQeDvjaRE/m7vDhTfLYlJ5GgLEgzLgGuM=;
        b=sURVx1FukJ+guDN4MMEXg60pe+od+Ob5zJWl1laVEPjGe7OFcu0V3o47aMYjcfi6yU
         BTYsNQCW9Q8Bd2eNW+RxEEx1H8ARLKxgArz1q1l0V3/ApnET4AM2eBNfoJ1UXYceqkAy
         RSvkHm/7JnXP1xEJpfMPDQxsiGFG6FeF5ByxNHKhGZPqPLZJZAacZALYDtMZralydvKd
         so1QUfKYzDvFUqVgbSbBnt+lZV7+qkmK6DChL//vswVqitQuNZATs5FRi9fpovtoNd4C
         cHwrX16eHI/E8I2A4ChwtdR+tDM19mePXilcc3lEW6kMN1KVNHPWnuHH2VnC/Y8YISEy
         O6dQ==
X-Forwarded-Encrypted: i=1; AJvYcCVp6j3+t4AP3dCxRjM0Z7gFhAyHkdcAs7zXEfRGwG1GZ8xE0gtTv3IaoYD8S+71jjtyzoOnBlACvHcs1Pgv@vger.kernel.org
X-Gm-Message-State: AOJu0Yxj1SGobTgT16CIpT7OxQJOSa+DTyuX4ZHyJBLiwQ67U4Fkd6Sg
	LM8xSgLBycfIyw9cW7O2j9ylqNjF/NsSeNRudRI42ARDuP/zIU+/FVa4ORJdOq/BmfsG0jJ6njd
	DRwBwR1lpWirtjErM2cm9r8sLyTVzp9PEN57MBsUzcvjegNT2yu+pu0EJQDI=
X-Google-Smtp-Source: AGHT+IHfdTrRhdyZ3XB6wJijBqmptBu3DqMxOJvCyZB34vSwaAse6RzFijYi6lrsi/1vwFX0auHyhwvXsWtaLfATYZ17mRqpsOtE
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:ca07:0:b0:3e5:5937:e576 with SMTP id
 e9e14a558f8ab-3e583804f82mr160391565ab.13.1755513663154; Mon, 18 Aug 2025
 03:41:03 -0700 (PDT)
Date: Mon, 18 Aug 2025 03:41:03 -0700
In-Reply-To: <CAOQ4uxiPPb70mx0Pr4Ph6hw2j63Q8=PZaxBx3N0KP=d7Ko=1KQ@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68a3033f.050a0220.e29e5.00a0.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] possible deadlock in bch2_symlink
From: syzbot <syzbot+7836a68852a10ec3d790@syzkaller.appspotmail.com>
To: amir73il@gmail.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, miklos@szeredi.hu, mmpgouride@gmail.com, 
	syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+7836a68852a10ec3d790@syzkaller.appspotmail.com
Tested-by: syzbot+7836a68852a10ec3d790@syzkaller.appspotmail.com

Tested on:

commit:         9e7e7e36 ovl: use I_MUTEX_PARENT when locking parent i..
git tree:       https://github.com/amir73il/linux ovl-fixes
console output: https://syzkaller.appspot.com/x/log.txt?x=11d09ba2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=41498776bd40da1
dashboard link: https://syzkaller.appspot.com/bug?extid=7836a68852a10ec3d790
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
