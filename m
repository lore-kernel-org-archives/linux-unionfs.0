Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C716A2185BD
	for <linux-unionfs@vger.kernel.org>; Thu,  9 Jan 2025 13:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736428439; cv=none; b=QeVOrH9ofYMN1guHjb83cHS930s0aH3cW0M40mgXOi397RAAflxoNSKVgFbe1Hwsb+PEIbI1epWkGO/UAC+HRPWp+DKGMy/1UgcmTv7Jr7WwZdknkz0UWpXVUj8WA3yOJVXlPXcQ8va74wN+jpdaej1IHVJXqrdg1ccFy7tcmzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736428439; c=relaxed/simple;
	bh=z0+5c2RmuHTV+YPKMhF+ZXxB+Hexc2PeT0DRWwpdgAw=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=bOvXnwMG0wIrhyyAswRPWNLTOpwrpzq3kUeUmYjbIQfIuVHv58yTlU0mEQuDLvXXOwPHiRFr8lXGsaXOVfWOSxv77vPSZW10lRjWg7MVJr+F6+Nw6YAopUT6pQoN3U6xRb9Uj101elaeTXLkKEMUsSPndzYCK66ZBZWxZBf8mAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a9cefa1969so8784605ab.1
        for <linux-unionfs@vger.kernel.org>; Thu, 09 Jan 2025 05:13:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736428437; x=1737033237;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z0+5c2RmuHTV+YPKMhF+ZXxB+Hexc2PeT0DRWwpdgAw=;
        b=L+1O4FltYPvZE7fFaKsB+HUHwCsM95aSWl9cEJU5EbFFKleoW6tLaOfYJBMLWZrj8f
         +2c+F9Z19cVdCY7/UqffHWHcXGuh/R6UN7KLRo7kNdmlJHWOqFDFWjUcr9L3mEFyLbo9
         BNgfwCqclM2QUFY1N6ytHJIThVsEtxsjLs9/Zzv9dju7oY+MbxTPx39YMrGpPt3fW3jN
         f8GlMqIDoCqvrV4xqjYUqjms04u5kW/VpgWnai0kX3HJVAjFIkdEjFGZ71nAHfm/P/S2
         Agtj4M3c3z/9Hh5aI6sPxgJObTn7gym92RnUWQ0PXecFeQR5upC2gX7NhMfBp8vXzXx/
         vbzw==
X-Forwarded-Encrypted: i=1; AJvYcCWbD3NqKeykLgy6MrD4JHwF6BipQvD6K8L3OtF1gWVdHGUp27qbw00pYOBzhN6I6DGo6tgN2DcCpsxhaCl4@vger.kernel.org
X-Gm-Message-State: AOJu0Yzw2BHVk28We7F6xo/D0NMggZCxYGbI/Ss6TkiA87hLQiiYpIbD
	p1DrGKBibHlgBqEOoVRDVDA/i+YqN+XW46IvI8kQHfO/MQzDBAr6cF5CPpGKFjwVOd1XK5wm+wL
	aDd+S1JuJPSEtYT/5kWwBGdDi5Ze8JE/Yy46VOdN3u1d5LpBCjNrsxCs=
X-Google-Smtp-Source: AGHT+IHZEftS9yCEjOgAbOXZXKl4rH91/TEZKGoA12KPWHxP8RRDFPr6+pnVlgq1brJNb7suWyvYGt7rgCc4d4xxUBTT68/KO99K
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3f09:b0:3ce:473d:9cb6 with SMTP id
 e9e14a558f8ab-3ce473d9f96mr24368585ab.4.1736428436988; Thu, 09 Jan 2025
 05:13:56 -0800 (PST)
Date: Thu, 09 Jan 2025 05:13:56 -0800
In-Reply-To: <CAJfpegsJt0+oE1OJxEb9kPXA+rouTb4nU6QTA49=SmaZp+dksQ@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <677fcb94.050a0220.25a300.01c0.GAE@google.com>
Subject: Re: [syzbot] [overlayfs?] BUG: unable to handle kernel NULL pointer
 dereference in __lookup_slow (3)
From: syzbot <syzbot+94891a5155abdf6821b7@syzkaller.appspotmail.com>
To: miklos@szeredi.hu
Cc: aivazian.tigran@gmail.com, amir73il@gmail.com, andrew.kanner@gmail.com, 
	kovalev@altlinux.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	miklos@szeredi.hu, stable@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

> #syz dup: BUG: unable to handle kernel NULL pointer dereference in

can't find the dup bug

> lookup_one_unlocked
