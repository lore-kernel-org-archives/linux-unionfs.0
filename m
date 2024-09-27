Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC28917837D
	for <linux-unionfs@vger.kernel.org>; Fri, 27 Sep 2024 07:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727422625; cv=none; b=OaJsSNF6ZGrymFvIgqfJJLuB4wpwFSt/6XhfaYcN1OP54rGNFTxybtLP4c+23uowJYQ74YEBiqD2rFZ/k7T8txq4IeoWr8zJ+m8HTmv+EzI+djiz+boBC+ooEL0XYVorV3DLV36tDOaqgkfS+93PzDsX2VS2bKXuoiIzguMQj2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727422625; c=relaxed/simple;
	bh=pZ1uB/XJBjEl6D21v2+KHYZz/RwbUjAFWAp4RP1NzPw=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=tyrP9oqcyKy7fA+fntk2evZ367Yfnaueuy5WrxbavMAGkhwKvWQif6DVfOA+ijkmEyaKwpQ5Gvj91dJMCJvLuVSILRvOqvSPN4TBj79X0XbdUyMqZX01uwO7NW09ySlm1GX5WW9cUNWhOj+vQzzBBgl6bfmxJC39KMZbLK+8q9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a342620f50so15301445ab.3
        for <linux-unionfs@vger.kernel.org>; Fri, 27 Sep 2024 00:37:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727422623; x=1728027423;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lehVuHc/G3YmOIICMpiPm5yqzC+B6vqDGq6lwJPGaz0=;
        b=detA6gu7SAcC9YWVXDrmSvSzDKxSSaw08tgzxzvizJyu/Zn3QZNJVNOZHyJsU+DU8c
         2ohzFG2j3h5U5vnTHkV3UhMSqVfN3Y8BdfAAKZcgf0yo4IkPfm1c7q2odb1K0HR4fHop
         vzZM2zRNbeJM3LgIsxXjTW4ncgdPiLcV1w6wJSD/E+xH43dPxuGEpS/uHeGEE5ZOjjwZ
         qBKK+/uS9DV1CwgsF/VK0yX6MCezTzB1hhryU/yXlCOKQd7DelZ2vQNzIZafFwh3bKby
         Yk0pj4aDLHp9/OmD9O8YhDnFDfIVYP4RH3QsIM/9qJpcEITAlGQjBSFNDh7BJMymlyeE
         dUGg==
X-Forwarded-Encrypted: i=1; AJvYcCWmXddIZQmSf9VoFdlYZCONT8WHMWTaRbjbHxKwKNlP1FO2l3/4/ucjR48f6uz7ZyU2JqVprTYKWjx/XN8I@vger.kernel.org
X-Gm-Message-State: AOJu0Yw18RBGO3vrfT4PXWBaAe/hFG6OqS3GidAwozyYbltRnJLOSASG
	8+gnGzXOBJqx3s2lRhdGYCOBAgtbWVr9uKMkk9IdSJhOSi0l6dgRAQ73mlIH/44geGZTRQFGuEk
	wjHsCsaFB/kpo03vV8YwBNljB6BIdOn3Knhaj6i49KBuz3bkJ26ncr8w=
X-Google-Smtp-Source: AGHT+IEpzlW7cze/+T+3UwIjnirvFs6E+EOntv3U7QiaD3/RHrulutVP/mU/HPA8uLNjjTnE+Ii/kMFgk68Gzr/2APctgN7uisyO
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:184a:b0:3a0:ab71:ed38 with SMTP id
 e9e14a558f8ab-3a345179e33mr20985775ab.14.1727422623043; Fri, 27 Sep 2024
 00:37:03 -0700 (PDT)
Date: Fri, 27 Sep 2024 00:37:03 -0700
In-Reply-To: <k53rd76iiguxb6prfmkqfnlfmkjjdzjvzc6uo7eppjc2t4ssdf@2q7pmj7sstml>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66f6609f.050a0220.46d20.0011.GAE@google.com>
Subject: Re: [syzbot] [overlayfs?] general protection fault in ovl_llseek
From: syzbot <syzbot+d9efec94dcbfa0de1c07@syzkaller.appspotmail.com>
To: amir73il@gmail.com, anupnewsmail@gmail.com, leocstone@gmail.com, 
	linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	miklos@szeredi.hu, skhan@linuxfoundation.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+d9efec94dcbfa0de1c07@syzkaller.appspotmail.com
Tested-by: syzbot+d9efec94dcbfa0de1c07@syzkaller.appspotmail.com

Tested on:

commit:         075dbe9f Merge tag 'soc-ep93xx-dt-6.12' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13ce159f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b2d4fdf18a83ec0b
dashboard link: https://syzkaller.appspot.com/bug?extid=d9efec94dcbfa0de1c07
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=112c6aa9980000

Note: testing is done by a robot and is best-effort only.
