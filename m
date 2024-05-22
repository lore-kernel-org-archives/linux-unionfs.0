Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21209140E3C
	for <linux-unionfs@vger.kernel.org>; Wed, 22 May 2024 13:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716384558; cv=none; b=o4CG5+4FRgNbYCf/TaLs08cd87JAS+1Xc6mT9G5kYuyQ7uR0I0allmjKhx2f1y6Un4YbzlSDqp+00CoFZaJfZg+SVYQsu8iqTInvAp3Byva6KH9qDAKnt0LN+wryjOTPRyn8IUKx3qv8HhUdU7eZiyuKCfZuXToyx4gAyAzXVrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716384558; c=relaxed/simple;
	bh=61mO5+snMGsz2ee+TFdxLBoONuQxJeAcSO8S6crnAK8=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=YaUm6LTRdodekJd7C2C6RHeL3hYRtkC1osMbaQwpCeitEkHhn2wOUOFIbVh6bjzbYWqTg4/8UOGM6fPa3NjVbjraGgdDJ1PD89w+yL9hNjFggC7FoM3Q+Q+xwQ+AHcKiG5a9HUzrYJvvK8+z365tQf+mquOdyQ9CIjrLFWPw2Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=eNfUi+JD; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="eNfUi+JD"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a59a0e4b773so974072966b.2
        for <linux-unionfs@vger.kernel.org>; Wed, 22 May 2024 06:29:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1716384554; x=1716989354; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fcAnLjMIMbITY++kSDoM1eUoNeGeLxhIN5O6O+u3md8=;
        b=eNfUi+JD5hCg56yJHaoYPZ74COFIf6NnI0qH9nL6BI8IxXaugOw9AW3WDE/g7eQcPq
         RTx94BQ/2OyeqmBZKoYXaGYV3g5OCVoTPNNg3hzW4oFWz36j3evrjcYaF7mINHHgHdPo
         0/kzMaf4396YboZdIHbbKGcEAJW0lSVIbfk00=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716384554; x=1716989354;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fcAnLjMIMbITY++kSDoM1eUoNeGeLxhIN5O6O+u3md8=;
        b=KWG1G4hafbssTAmeiHBCRMH3Q3ZsH4yFPSyUmaXvaYB8heI6hlalO1xCRybUX0+3KT
         aRxaCnkphXywpY8viw3CtVE8vRvNS4OLSSWinXhRSJ/N9V4ZjTvvPFx0v+zJgF8y+IkN
         vc+8QfR+QEzOiA6SagXlZtGbq+avmWthOWA/8rL/7xhowGl1Wvoolg1cvuUnurn+LtL1
         KuUXgThaKe3mba5ymgfuLgw5R3MdeH0dHqDBk3zsv4a2dPFuWlXEdcUJ54fDk4xHSgR2
         Du//j2XCbac6GDcKB29JulcZUlCv5OZItLsNybbOLXGXzqnG2MFDJYTdxvu/cF3vQbjb
         p01w==
X-Gm-Message-State: AOJu0YztDWGE14F15fgWG2mE7HLiIUQEYwdTKdgrA9HHEXHe1RLGkdlC
	mYdlEMO1V6T3rHN75++JyJ/nUgi+O+sCrykpQG0vd0DMFTd7KSiRWLFU53sQxWc6DcZPlZLcVx5
	qH9RaBGHAJKBXdWCZCtZw5+zNerYV4vo69lFvnw==
X-Google-Smtp-Source: AGHT+IEkcTSyEUkeYpXWY+h3epaoj2bcPKEEthTvq9ZR3Kgjf4O9kooRyINxL3rDCrzwmh3KjLFlaI17FCigLPEni+M=
X-Received: by 2002:a17:906:6884:b0:a59:9e01:e787 with SMTP id
 a640c23a62f3a-a62280a0e9emr136501566b.34.1716384554522; Wed, 22 May 2024
 06:29:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 22 May 2024 15:29:02 +0200
Message-ID: <CAJfpegu93nZEeEJhepnDhzHO7khEmXkP1UssKNErqXFFUw-8uA@mail.gmail.com>
Subject: [GIT PULL] overlayfs update for 6.10
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Linus,

Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/overlayfs/vfs.git
tags/ovl-update-6.10

- Add tmpfile support

- Clean up include

Thanks,
Miklos

---
Miklos Szeredi (2):
      ovl: implement tmpfile
      ovl: remove upper umask handling from ovl_create_upper()

Thorsten Blum (1):
      ovl: remove duplicate included header

---
 fs/backing-file.c            |  23 +++++++
 fs/internal.h                |   3 +
 fs/namei.c                   |   6 +-
 fs/overlayfs/dir.c           | 152 ++++++++++++++++++++++++++++++++++++-------
 fs/overlayfs/file.c          |   3 -
 fs/overlayfs/inode.c         |   1 -
 fs/overlayfs/overlayfs.h     |   3 +
 include/linux/backing-file.h |   3 +
 8 files changed, 165 insertions(+), 29 deletions(-)
