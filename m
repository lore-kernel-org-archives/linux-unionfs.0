Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FCF414AD29
	for <linux-unionfs@vger.kernel.org>; Tue,  8 Apr 2025 06:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744093059; cv=none; b=ZTo3TWzw3HA9f4ojiZrNPzxyo6zc+aaH0cW2Bkz7kFDlwWJk8k97oOZogYw59isWiiGOY84yMpzkhLmaATN3IWALGqXxV6dauPL91uSSuqITouyoecxAlm5THFppMx3DcE+N3WUKlXPlDjN/aaT6AgcFkUKb3UPd6YCaQ7gkcN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744093059; c=relaxed/simple;
	bh=VW+RsJJRpNN89PxvKgUJK1GGasY5iK6flMlTkynIT2M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JxAmNlH3E1PjlC/e/Sw0fpDZndzYGPvzQqh16kOqDP4xFf9NzIhTQ4Z0cEwR1WMY6zMbNQt3SyEDntzcvw3OYXIPYe/0xLipvQKzEKb4vz3k61EhSxBKrbkJ1iYVuYXoFTYUIwYW1qO5IQUh6Ct5/HuB2xzeQrLx2jhpzEeH3aU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=b9pcGPhc; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="b9pcGPhc"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4772f48f516so60207691cf.1
        for <linux-unionfs@vger.kernel.org>; Mon, 07 Apr 2025 23:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1744093056; x=1744697856; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=nS5SAKrFs9L3a7bg9Pf2lyrhub99zp14T9x9IO3i5/s=;
        b=b9pcGPhcGEOcqGDWMudRHPYphk1lVLBJqaQYr5QK9mEKrjiw9vWO/w49x1tUTB2hhm
         WZltNtxI54toK4cvK8lebAzM/m2L4s/KeWW7Iux1V42fdNeuzbcvIjq+y9zlnPXiB9Wo
         MX3WsGGopiMR9+d+ZtIiBGOITIIoSx70S3YfE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744093056; x=1744697856;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nS5SAKrFs9L3a7bg9Pf2lyrhub99zp14T9x9IO3i5/s=;
        b=TwooDm/p+moCyQhDfAYkcg+3NGBFQVhJeLbLZa1evSI2h/nu3Uo81bwDqaLQqG7hSg
         Cf0B5mqftUMjvEePS+Hw5qB4I50GzNPaaYBrPINQgZH42VqnNvXiK5NOJ+LDL+GAWmXx
         ADeNF9VU/zXGqYPzTrTCVyTiqKK10k2VsSLly9xL+zy/TVKfHt7HzpywclWJWR1fV0vp
         5QpRm4X3+4JJAEY2yR6UfPYOMbCuPJcWAQJ9kbkdCFBOAJe+jpSohqbSOmhw2kKMkzLQ
         frirghpsJ2MTD4fYrxgEbWm/mButMVW1ocaPJ/Zrc9ZPLi6lOWJ/8F+FYiIWrMX5Li0b
         BFMg==
X-Forwarded-Encrypted: i=1; AJvYcCX56YsfY8DmvuU11Hdlr6w8fbJF0M4Yn4sUNlYDQalcGImB9TdkNaWJU6tEwwHZN5/nd0IzysnJnFCg955h@vger.kernel.org
X-Gm-Message-State: AOJu0YwuOOrAX18HWbFEKBRGeHfLAuNDkpe7BT873afjMbr7rUgSC9h9
	TWrVu3pQm+4VU5IAuI6Ks6I32pO514dewDdE8VT3ClijRFsLe1oCs3laDYDIK+Fi25c7nBaecuw
	BSjS6HKmS+BYccoXyp98IisFL5sQZz2eETTjcVQ==
X-Gm-Gg: ASbGncvHT6wP8ffkwpWu0bgWgEw7uZJ9hOA1Xxd8PWiguMkTcWUgVCQZesh6cAzp9QY
	IRZ0v9KLq6KjttHr0s/aJ6jWNgvIA+2oDxzvkm9cdNk/7I8XkogP8CqslZPVbLAYlZkj2Bdl2hG
	20MQeBPcJDXoDeVvK10xLURjJNHH4=
X-Google-Smtp-Source: AGHT+IGN08NztWSyO7oZY1PKzyq5lt8yT3Bg7u9DzpatY8aRQSviQxIWIRLmXD23CvcOoXDn1LuSBR6ZSex14gtyN48=
X-Received: by 2002:ac8:5a8a:0:b0:476:6df0:954f with SMTP id
 d75a77b69052e-47953ed2b21mr36161891cf.10.1744093056143; Mon, 07 Apr 2025
 23:17:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <67f3dc05.050a0220.107db6.059d.GAE@google.com> <1465443.1744059739@warthog.procyon.org.uk>
In-Reply-To: <1465443.1744059739@warthog.procyon.org.uk>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 8 Apr 2025 08:17:25 +0200
X-Gm-Features: ATxdqUHATzE8R7-GtRDaTuVwk64W_yazPWFWR845MefAQpWOnCnETGl6AzmpLJ8
Message-ID: <CAJfpeguEd49YhmbsZYPgKJ4=BYpgEEhF7gnH2Cp1yRouQUUMWQ@mail.gmail.com>
Subject: Re: [syzbot] [ext4?] [overlayfs?] WARNING in file_seek_cur_needs_f_lock
To: David Howells <dhowells@redhat.com>
Cc: syzbot <syzbot+4036165fc595a74b09b2@syzkaller.appspotmail.com>, 
	adilger.kernel@dilger.ca, amir73il@gmail.com, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"

On Mon, 7 Apr 2025 at 23:03, David Howells <dhowells@redhat.com> wrote:
>
> syzbot <syzbot+4036165fc595a74b09b2@syzkaller.appspotmail.com> wrote:
>
> > syzbot has tested the proposed patch but the reproducer is still triggering an issue:
> > unregister_netdevice: waiting for DEV to become free
> >
> > unregister_netdevice: waiting for batadv0 to become free. Usage count = 3
>
> I've seen this in a bunch of different syzbot tests also where, as far as I
> can tell, the patch I've offered fixes the actual bug.

Which one is that?  I can't seem to find it.

Thanks,
Miklos
