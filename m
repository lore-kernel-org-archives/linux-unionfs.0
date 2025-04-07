Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0D71C3029
	for <linux-unionfs@vger.kernel.org>; Mon,  7 Apr 2025 14:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744034824; cv=none; b=o8WxPTTLqUIdJQQH44wFR4DeD7+yU/53ZNKTynS9c+itg7PVcoY/7GJ+ewUXxB22Ym5tXBIL6ypiOZcAJaxU13gb0voh8s66eRF8FRzVlU0b1yusa4C9UqwrO8mZrQ/a7F2auPyr78gnIb/WJmTL9lSSwTC88rtRpd8rPTdLyf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744034824; c=relaxed/simple;
	bh=ncxjzCSmxOakrfI+ux5lY32lyCKIK2l6GJc70zdDPOM=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=FcztqZDdQXshj3zHjnasyo+3ogH7DPCQs5C99IyqInxja0d4Uhk3QpPt+LNSaaE3xDSyQpbRvkKM7UtAo/5rHNw/fq/dVqAetF/VT/cfgbA1rWm+BpbIqBaR9kgMGgHHNusfXuifWrphbQmQDNSapIPxVxwNWcgrpOD53ldlJxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3d5da4fd946so89799985ab.1
        for <linux-unionfs@vger.kernel.org>; Mon, 07 Apr 2025 07:07:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744034821; x=1744639621;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GwXWzXPAt90Ym5+D6NPAF0rUeU+1DPFdOJn+FQQCuts=;
        b=p8uuxrbR8vx6Xdc8KOisNe9QL1no94YMNbFOtK8ABCw5eqSIqkLrv1uz5a0FjKL7K0
         VJGJbRU1IIyBOaVf0i39P/fWDW75mx86zdKrfUVdE0/LW28vkpNiFqiR4ZRpVlD4uqW9
         5k4R1l50O67x/L1HH2eePfQ2RjpVf9JylmO6QtwdhN0hU9ajnREuezq4avQt37kouhfp
         QMLmVwvuQfhccl9l9+42vNkE1PmVdBuU9t6LYo1a8wK4ATDfZeO+Dsg4ksp4SGxCZK1D
         BlE2tLrlfcOb5dGQN/uz4tNmk07KOi3iB56luDJLZ09tNSpMhMKkvJTo38ghbbYTG3nE
         A6aQ==
X-Forwarded-Encrypted: i=1; AJvYcCWoDO69IP7RVAwWRlmPIeJ4WiZmG4AfSCKxmKGrA9UsrTiFqKkmzS5+iKBiKdJPDR7wTNe8MekCtudDC5Pb@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7M/jpMhLyUQfcb/XofNKoE8oDfDD0lMr27AXjpYQGgCqsq7XW
	1lW1/UD2UimRK9KoF1gE+cEOtXs2IjLx15s4An/TCLs6xeiJ0CpjEZT2cNYSwDsBj8iO1uCP0hD
	7l4K2CWNQ42HWS2DvjthmwjsfN6IwPSSFBnl8tzQ4UaEllW/q17zfMBQ=
X-Google-Smtp-Source: AGHT+IGk0qg4Non5+RqSgTngMpr84QybCMyGxRObEpMS/OBnGd9K0v8L1YYw6HKMv3i9T2PNneYp7wP0WdoYv8xmIodS/MaJDTO2
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:cda7:0:b0:3d5:d71f:75b3 with SMTP id
 e9e14a558f8ab-3d6ec57f9damr97693795ab.15.1744034821687; Mon, 07 Apr 2025
 07:07:01 -0700 (PDT)
Date: Mon, 07 Apr 2025 07:07:01 -0700
In-Reply-To: <CAJfpegvsi9SaeVdykBFhhwoOrsNQzy3C8HcJjn16uHdkzZ-EVQ@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67f3dc05.050a0220.107db6.059d.GAE@google.com>
Subject: Re: [syzbot] [ext4?] [overlayfs?] WARNING in file_seek_cur_needs_f_lock
From: syzbot <syzbot+4036165fc595a74b09b2@syzkaller.appspotmail.com>
To: adilger.kernel@dilger.ca, amir73il@gmail.com, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	miklos@szeredi.hu, syzkaller-bugs@googlegroups.com, tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
unregister_netdevice: waiting for DEV to become free

unregister_netdevice: waiting for batadv0 to become free. Usage count = 3


Tested on:

commit:         0af2f6be Linux 6.15-rc1
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git v6.15-rc1
console output: https://syzkaller.appspot.com/x/log.txt?x=123c0070580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bae073f4634b7fd
dashboard link: https://syzkaller.appspot.com/bug?extid=4036165fc595a74b09b2
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=151deb4c580000

