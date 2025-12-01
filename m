Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFD7B3016F1
	for <linux-unionfs@vger.kernel.org>; Mon,  1 Dec 2025 10:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764584284; cv=none; b=OVzrT7RL5rQba/sFxHWE4vyFeQM4myb7QUSghLzL5ErARe65BpUDo2jFWtXuTmatOoq5fwq4Yx+jJB6nTcxS35ovgZ18s0/TbiMLaMFI1KgCug9GktZzcLvF9ULAG11CyMpvJAR02IhzVqjuqxdIExzGUApw87mWpFxAkFPB5Qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764584284; c=relaxed/simple;
	bh=qYjhE5H+tepDnQR/NdXpP5gvxFSCnek9nanqQJNe0go=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=Ft4JGyuAz7Nxkc6dnS8rsGtSPSjoiHabugMYVG8lQKqzLEp2VNvTvYrz2yOA2oyeIocootrETsBD8EzVy1rPuq9nJq/W/wHESs9Sdw5LMdDnY7lDsb/uc5YWiCDytlUI0avwJ5mkJlDWLyLdgdNHP+ucY+ofxKPydt8SeK0yFAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-948ff1d169eso262994239f.2
        for <linux-unionfs@vger.kernel.org>; Mon, 01 Dec 2025 02:18:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764584282; x=1765189082;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kSD+sE6WJY+88YLTFb+oiMUjRjH3fxhhKy5ySSu+aFo=;
        b=mYE09cl7/A2zi8d14itodhvesAZTn4wWP7yGsDvQskwCFxoicliTtOpVv0Ai1sTD63
         +3lRjc+Nxz/q1nE+yOrsXxJ2A2Vd3Thyx3gO/4/azC5Nw0qDVPjYNksPnRVkloc/H5Rp
         KE0BpTXJvgut34YfoSm0xzMRr1AcqEDWkPC34Fm7lclZfRdI3gXF/JoRtXY9kz93/Ev0
         xtHJ5RAnUduxUxoq2DuSMinTyvlxHS54FgWtoCt6TuZvbFwRtCSmMekglUME7h3OAdPI
         K1WHKMGhxJskvkDwJYP3N3ggdlVKWU3vDcKfkiZLtzqy5sf6LXG7Afo+tN7+A93G9tVr
         03vA==
X-Forwarded-Encrypted: i=1; AJvYcCWaItqAHm7Ua+4UQ03CEdsdR584uDFfI4lXQlzyef/7bQjmF/cghDUnKU1lXVs5Kvk4AwGGNlm88Luw0XgJ@vger.kernel.org
X-Gm-Message-State: AOJu0YwFSvl7QE40UMh66ZhZCsZ04RBeARztwdzpOYuxEHK4WICAZp+U
	9E4JLlws80/eASOngoXIeMr/PYl7dP+/QJ6Cz1tIy3pFnBX9omybls8VMogzYUmTY7BeXS5QPLI
	VP1uBoCLNh1bpduotRXdyn0MC8m0LIdxb+6MKh7uOwKX+8M4TcYmtl9MQ1vc=
X-Google-Smtp-Source: AGHT+IF7XHa4xKbbMTUcDRlaiHw8odsMwQjNRahHEl/nAczVPFt9/Ga/mhJjYvO6JImrwnjh/URNAPkJSwQuE3tsHrjmtYHV+JkU
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:11d7:b0:5b7:267c:35c7 with SMTP id
 8926c6da1cb9f-5b9995d68acmr15730270173.2.1764584281993; Mon, 01 Dec 2025
 02:18:01 -0800 (PST)
Date: Mon, 01 Dec 2025 02:18:01 -0800
In-Reply-To: <CAOQ4uxhPEt76ij9zBtdKf0qYwSjeXquGGkLHeArO5t1LhdTHOg@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <692d6b59.a70a0220.d98e3.0182.GAE@google.com>
Subject: Re: [syzbot] [overlayfs?] WARNING in fast_dput
From: syzbot <syzbot+b74150fd2ef40e716ca2@syzkaller.appspotmail.com>
To: amir73il@gmail.com, brauner@kernel.org, jack@suse.cz, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, miklos@szeredi.hu, neil@brown.name, 
	syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+b74150fd2ef40e716ca2@syzkaller.appspotmail.com
Tested-by: syzbot+b74150fd2ef40e716ca2@syzkaller.appspotmail.com

Tested on:

commit:         7d0a66e4 Linux 6.18
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10b5c192580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=859bdb453c94e06c
dashboard link: https://syzkaller.appspot.com/bug?extid=b74150fd2ef40e716ca2
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
