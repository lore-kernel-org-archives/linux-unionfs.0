Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32F519F137
	for <linux-unionfs@vger.kernel.org>; Wed, 27 Aug 2025 18:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756320490; cv=none; b=d50X2pmfuzv6MQAmg23npT5Rxucle+buk9GvvGvJL5jRAwxFnmPxsJ4lJzgGe+Q9RuhkrRE0OpRdJwdZr9be80Ryk6j53wn6CCTPGL9mTEZQ7nYJc58KqQaNVACSWuu2lXHi+P5w/9juf+HmnQN4z9GLxAvkyMMQ0KE1y3iHZd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756320490; c=relaxed/simple;
	bh=ZKABwh8CPMiBrKVh8SSKQwWIe8IPvKJSfpJYNTT+9kI=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=ebgQbP0LGRYiHjZsxPwKvluBIBf/UxdgxBXLeMt0LdFSmi/8JqeGsR4jaf/EUjtV91NQeAixHzsrAjtn4KLYuRghH1s2zoC53SbSvDcQWLsM4dUL340BfPdVYurVRBzAa7WZlmDZ9SMjwhyN2WZgq0Po0FB8Y9P7laZhHKFE8tE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3eee0110eb5so2786625ab.2
        for <linux-unionfs@vger.kernel.org>; Wed, 27 Aug 2025 11:48:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756320486; x=1756925286;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/ZmRIpbQm+3yh9D0kp02qhNvxq2hCOcLzVcLSfknKG8=;
        b=CbfTIoyXsnxC0Ygc278b8c33GQLNOpHd5bmHtMIaTqBlUYweMI9DTBBVbNa/Z8HOFW
         QXijFXrudwUOk2lZrf9iy6it67zz3Ul1dYypDaBq7ojDFXvE1zVXT+eeeP3dr62eUPcW
         o34SaHUaoS5PX8Wcg3qDKi1MmNa+Oejga+35078rgAQbe8ehVC12NsOkZOmCJrDF7O0r
         qAq37QYxQ+SfLmpJrrmse/KvpxlkktZiijFNB0/fbZtQqN6WuUVA3tVlJYsOyIRt0UdP
         BkimgdtRmoqmkRuuL8tfRfSYFqdsW7PtnzJqBjD2wJSx+JrW2VYTc71B+oyjxkFxMaPu
         W/2w==
X-Forwarded-Encrypted: i=1; AJvYcCWG/sm98OgnZf6kJC37DEZSCZQx3N/dgXVUk+/mq1HxGQAGo0muPGjTv/+IaX7QpCK9rG2d9MH5JJFgB296@vger.kernel.org
X-Gm-Message-State: AOJu0YxYm34hWr8387qeU5r9mc+VO/4PBj8JAACubHZo798D1NGze/xa
	XcNddO2WfHh6zl5wW0cg3E2MlSBNolPaTfCOo1dR/3Q5Y6F+Bj+cyohNZXsNPlg9/kvriQEdLDs
	/47dFDv682B2cWXKduLBIsMpqAmUDYcT08WqO9iwQsxqBMbtOdeJrDSoubDg=
X-Google-Smtp-Source: AGHT+IGxdf+5asFtx9Ejzpxtt7kfXutYSWZMjvbIUMS6RRXvb8DQ+zfYkl+ZHwyu6Q09DYlJekMtS2fu5XruHw0bFv+t5+JaKr0M
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:b41:b0:3ed:4f7a:9065 with SMTP id
 e9e14a558f8ab-3ed4f7a9383mr140209645ab.28.1756320485955; Wed, 27 Aug 2025
 11:48:05 -0700 (PDT)
Date: Wed, 27 Aug 2025 11:48:05 -0700
In-Reply-To: <CAOQ4uxh_yrq76Rq9RoykGdANZNBWc16UgbSBRjDtXKeLdA7-3Q@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68af52e5.a70a0220.3cafd4.0030.GAE@google.com>
Subject: Re: [syzbot] [overlayfs?] WARNING in shmem_unlink
From: syzbot <syzbot+ec9fab8b7f0386b98a17@syzkaller.appspotmail.com>
To: amir73il@gmail.com, andrealmeid@igalia.com, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, miklos@szeredi.hu, neil@brown.name, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+ec9fab8b7f0386b98a17@syzkaller.appspotmail.com
Tested-by: syzbot+ec9fab8b7f0386b98a17@syzkaller.appspotmail.com

Tested on:

commit:         5dfcd103 ovl: adapt ovl_parent_lock() to casefolded di..
git tree:       https://github.com/amir73il/linux ovl_casefold
console output: https://syzkaller.appspot.com/x/log.txt?x=1040fc62580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e1e1566c7726877e
dashboard link: https://syzkaller.appspot.com/bug?extid=ec9fab8b7f0386b98a17
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
