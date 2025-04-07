Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E5B2222B4
	for <linux-unionfs@vger.kernel.org>; Mon,  7 Apr 2025 21:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744060204; cv=none; b=b2yL7mbQdb8W/qYoYvPr9F5Jft/GnXY4o288BJD2KAmRV1URqZhhbHSTSVByJjR9syALHrB95wkKKcg0a/QDiTbos6admuYTV/PtQ5ZD4WwQoroAchiG8WqrcaMJ4JowCsjyG6mwPwNDLZr/jcfS2vqct3ZwsUYgySad/ljP2mU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744060204; c=relaxed/simple;
	bh=l33H7W/dajNswr6zoB4uEzQnZ3xV2ksVZyWMgdOsk+c=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=vAtoj8s/kJS1na+1MBSBYdvPtsUajSTZYKg1Xch+nvgPqOZzr6tLxBjgUZ0PS7eCfXF419UgAqCdfbdAUBO0/cJmX7b+UoCM0f/N6ZQqdVo0texHOZsi+wRg4vSJ8gEZoZVRdau5lmLJ2lHFKUSh4aa0yuB+kfrLLM3bL5r+vjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3d5bb1708e4so103714345ab.3
        for <linux-unionfs@vger.kernel.org>; Mon, 07 Apr 2025 14:10:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744060201; x=1744665001;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=obSJQ5g5QULaHlCzGG1efUqikPTPRZ9Sdsw5hiAMvVs=;
        b=W+UsEKz1JHXAICDOfxQQ5gcfr2Oj/o6Nuyr/2kyjy5J7IuMqJsOkiY/yXoXSo+vlt0
         VMgt3b80FobB/FNlW1ErX8tujdSuS0vjs1BcNJ8rMcag9Z11MDRLfAfmxhtRzC8YzRr0
         5RvP9U7OghLvbF28RErIJYH+rtiw/M7hcn8YFZlWLf9AK1sGB9eN7jcdKxjzcAaq0NI3
         fqy1AgVaGBpJ4D2o1AW/q9+mvU9k6zp8/X/wmKOevt3Mk8FUjRSyNfFIYc4Nl1WivhU5
         54+ivUj3/TZnQ+Xt/nMECv5QOTpRg9+Dtjmx/FHCb5oc279JawcV06ehMirLs35H32Jy
         pnSw==
X-Forwarded-Encrypted: i=1; AJvYcCVbi5TN9cCJVoHcbBkjkkBG6buVU2cs52yhIo9LAaPxJEQjq+5Q+WE5htNCTqCLSWFr9dnj3MvF94sxXXs0@vger.kernel.org
X-Gm-Message-State: AOJu0Yyl3eZIwTEFpxOiCsE5G8gZ5qDasuBt6g0+aXxuSu5qotlZtW1c
	sQ4DnA9Xl3mlz0NxTIrqro50Yp0eTh3BQLho/ox6ZDARmjRMvf2JgVH5CPv/E0EWd+NSWqtfiRi
	yDyjTKwPfO5aF2gsxdvIvQV2hMqsaWNoY5xtUaVu3hnC1Bg2uqhV6BAc=
X-Google-Smtp-Source: AGHT+IH3y067eDUmOjv5CFVChEZZ+wYOKbqcRDrio8C6VJxigSI3fEGx40IpkZ9McIdubTIYOFN7nscVeIXbCNAf69zlWSylOENX
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2199:b0:3d4:244b:db20 with SMTP id
 e9e14a558f8ab-3d6e3f653acmr156570565ab.16.1744060201704; Mon, 07 Apr 2025
 14:10:01 -0700 (PDT)
Date: Mon, 07 Apr 2025 14:10:01 -0700
In-Reply-To: <67f34d24.050a0220.0a13.027c.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67f43f29.050a0220.396535.0554.GAE@google.com>
Subject: Re: [syzbot] [ext4?] [overlayfs?] WARNING in file_seek_cur_needs_f_lock
From: syzbot <syzbot+4036165fc595a74b09b2@syzkaller.appspotmail.com>
To: adilger.kernel@dilger.ca, amir73il@gmail.com, dhowells@redhat.com, 
	edumazet@google.com, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, miklos@szeredi.hu, sven@narfation.org, 
	sw@simonwunderlich.de, syzkaller-bugs@googlegroups.com, tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 00b35530811f2aa3d7ceec2dbada80861c7632a8
Author: Eric Dumazet <edumazet@google.com>
Date:   Thu Feb 6 14:04:22 2025 +0000

    batman-adv: adopt netdev_hold() / netdev_put()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=175f8c04580000
start commit:   16cd1c265776 Merge tag 'timers-cleanups-2025-04-06' of git..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=14df8c04580000
console output: https://syzkaller.appspot.com/x/log.txt?x=10df8c04580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c79406130aa88d22
dashboard link: https://syzkaller.appspot.com/bug?extid=4036165fc595a74b09b2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14f9bd98580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1571c7e4580000

Reported-by: syzbot+4036165fc595a74b09b2@syzkaller.appspotmail.com
Fixes: 00b35530811f ("batman-adv: adopt netdev_hold() / netdev_put()")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
