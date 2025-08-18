Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D05A5475E
	for <linux-unionfs@vger.kernel.org>; Mon, 18 Aug 2025 09:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755510425; cv=none; b=leFAzZgOZ9XNvDRQfbbnYdlJsir1TF5zJGxy2P33I9WUozo2wD8tItZsPdHEG+AhnfEN5n2LLw/20j+lGvRKDebXa7b2hWH28i58CsApAHcIVSih/EsfezaZMt8DvXTyN1L2mpRrdM5Q++X4/YIPM0NEBupONYyPfnkItZo57Bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755510425; c=relaxed/simple;
	bh=j+FmuxJLqFJHowEK3/yJtg3duqQ4gE9lojwmJG6bfOg=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=jdBswwMLgHiZXBjsQ8TPtreYUiZmBKg9KJfVeW8naWCuuR/zL8icg7WBki6nZMsCxL5h312Toq3VIUxhCbxUXHwFeJKAHXMy2TyahXptvHzRwY5imtmJUYrAieSpGPfuGTR7EzQQYOA1GCpy8PeVOZt/jwdF/Rzu+PJQIP3eF+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-88432cebd70so1079973239f.0
        for <linux-unionfs@vger.kernel.org>; Mon, 18 Aug 2025 02:47:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755510423; x=1756115223;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PkMjJGrkjVySoMn5WUIsXfAuu46L+OAHGE+8UPnrlbw=;
        b=K2bWW+WSUcSdWge8jCAuJnbdXtV5brPL+g2yWc2bXmrLbpE8W95a9AZ69kfuZpaDs2
         srsVl/5HcUQb/hfSwmbZUfrjq5drPLBK2PcSzBMI5+93Y9yBEs7MMTXLYafdp2yZ1gA0
         w680ddCwYLTSsuxWAXAkVW55wwAlppGFnwhEcHDjo8FOzKGUzCJqBKhdh53PmV0gj+fM
         pla9tNCbfAFdddStf59wKMhp+FZeb7w1vikABMwD1EGsZ49pdqpDojlvu9W9aC5lGDiR
         B8RRjrz+uu2LsdPHV3PLRYCj1PHzmYKONW4mJ9xYuKR5nDcyiw/KwmYSwVnSr2qWEzdE
         SV3w==
X-Forwarded-Encrypted: i=1; AJvYcCWVSGbHGz1AWkkdAy4AzfhvZs7OvAYht40qCG2l1yUOu0irPveeVbLiGRMgvoXYvq6dXPF2Y4pu0Gq/YJiV@vger.kernel.org
X-Gm-Message-State: AOJu0YxZFJYGOmTIRBljaQL6JqtKuYpuN0WXUfj05ee+vTInTkdUKTP7
	wPZBqDrwrGNNLn0g83WUqRQtrAAheIZf6LmKEMkJH58o6pKhzst15fa5BKv8JL1lPkB5UIdd1S4
	BH498EGb5ehyMgRhOYiOgwM6z9EJhMX+hywqDaOY8if+ak4bbo2AVZ3NZV58=
X-Google-Smtp-Source: AGHT+IGWUcZwKlpR1WfhXpRXr2xT4iYjelxQ83g46H3PivCQEmEjdRaEaKvXLvfVzNk24rULoCFJxycHskTkQu7aCYcK8E5ZRKJM
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:27c8:b0:876:adf1:b263 with SMTP id
 ca18e2360f4ac-8843e3bd847mr2426139339f.6.1755510423112; Mon, 18 Aug 2025
 02:47:03 -0700 (PDT)
Date: Mon, 18 Aug 2025 02:47:03 -0700
In-Reply-To: <20250818091720.4948-1-hdanton@sina.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68a2f697.050a0220.e29e5.009e.GAE@google.com>
Subject: Re: [syzbot] [overlayfs?] WARNING in shmem_unlink
From: syzbot <syzbot+ec9fab8b7f0386b98a17@syzkaller.appspotmail.com>
To: amir73il@gmail.com, hdanton@sina.com, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, miklos@szeredi.hu, neil@brown.name, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+ec9fab8b7f0386b98a17@syzkaller.appspotmail.com
Tested-by: syzbot+ec9fab8b7f0386b98a17@syzkaller.appspotmail.com

Tested on:

commit:         c17b750b Linux 6.17-rc2
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15e1eba2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e9f694461848a008
dashboard link: https://syzkaller.appspot.com/bug?extid=ec9fab8b7f0386b98a17
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
patch:          https://syzkaller.appspot.com/x/patch.diff?x=1413a442580000

Note: testing is done by a robot and is best-effort only.
