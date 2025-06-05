Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E8C17FAC2
	for <linux-unionfs@vger.kernel.org>; Thu,  5 Jun 2025 14:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749135100; cv=none; b=YJ2vSo4awhsHhPss8ohdw0/Q/n28gI8vkczuTXksAjTXF4oLj+KHrdHhDB9u8Vma+NB80lrtWDAlwwP9TmYSGk8Passam/rZMxF+z0NMyZOvRc0y3h4RcWI6AJTf8QVf3RrvVXwwEYBwa1f81q8iCVxWe+j9Xa3KdXOeOahtXi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749135100; c=relaxed/simple;
	bh=8opYR/RLHE+c4NG9PfiIatcqdYIIGlAtUPp/Y7mK/SA=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=WfCQwpyyCK8qt27sIFKjsDCycu0sv03iKbwPYZbyOPBWwU6XnI3GVTsqL/HoYLp/3jEqnlqgi6Er7ga/iKMKbsmPEk81f8MtVV9+nzHb/cAhOpnn4Mq8efiMQgShdXqi4Sn//G8yBJpEXOaN+Y4VjKq7KkkOGP8w5nJQ8R2lcBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=ePrt0JgV; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="ePrt0JgV"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-22d95f0dda4so14147585ad.2
        for <linux-unionfs@vger.kernel.org>; Thu, 05 Jun 2025 07:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1749135097; x=1749739897; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0qZIyhLNfUK8aRt0IjyGDdUz2kW/fFohhjPr9dq+tBQ=;
        b=ePrt0JgVhqfQYTTmoGYfMpd1fOibsM7Po0g2kPJYRRsNT7UxFnpvyd8X4lb1e3ID4o
         plEOfYieBq9opx8nkCVgSTtZGqFZAdlDqQ+exp3nQH5O9RJNif77JxJrzFJh70+HB8++
         m+V0GxDUWiyCWwqyzBou2ouYZ+tSpOEuV1/mM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749135097; x=1749739897;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0qZIyhLNfUK8aRt0IjyGDdUz2kW/fFohhjPr9dq+tBQ=;
        b=g1NCSEG9564sAgHu86MuarInBM9JnBfQbixi6itFLfYpiQW1nwLZYJJFkctjnzvhvK
         zUbN8miz3KrznztYyjEZtQ3rAFDEbLNKr1T3t9NuwIo9jt08gCO14bahTeFxumhg1e3Y
         I9b7xbxBE4wyuTj6bCuMmxBn7djsMQkvRieYrAH3uSPtss+k4E4JDdGch9ktEJYAIJAD
         4fefK3ZwiMxFEHBIrINu0InQNV4sUGOaMW5mFnljGPKCDJQtfe2taRYLNRo0uxJnHZB5
         9qIke1TNchSo8a+o7Vdy0Zqa6djSpq/Mvl1v6tDPCiG7xcr0W98xpqma8ewzc1odGHdA
         EmtQ==
X-Gm-Message-State: AOJu0Yzinchtp8cEgRMCTNyj7K1fGx5eFBZTQSxDk8nYWJn0mPy0JaeT
	eueF3zNyNCY/p69rajb8vRKOifRLhFOevnESERlpZRXV+6XuOw0Gu0z2ZA7UUc/lIn/lONh54Mg
	/6a60yuUUf2jUGywVkTykr6jAb1sbiWJVkZzcoAtXxtKeLv94CtKoQhrnZw==
X-Gm-Gg: ASbGncsv7yeD/efjo9whUMUqSyomxb9+DEJ5tbN6PSw0dOiY9E2mhV81t9JuyM6hEha
	koxaezyueVlh1xVnoD46ES8SVIpk9AqbvFBO3WiDAFvm28UUWxlsqXKvxpjzzGsbPuFRvkffbsh
	C72RoNKnySKQhvNWURHfjzZILzkS+OTnY=
X-Google-Smtp-Source: AGHT+IHAbJn7akHP0pYrJh9k1QTBH4AMnJ3AUW68Wk+P5THmWTp3kCTbbGZ2EV9/S5oBNPTKOCVGI0vam2239o4+gmA=
X-Received: by 2002:a05:622a:5a0f:b0:476:7e6b:d297 with SMTP id
 d75a77b69052e-4a5a581c203mr125679031cf.41.1749135086307; Thu, 05 Jun 2025
 07:51:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 5 Jun 2025 16:51:15 +0200
X-Gm-Features: AX0GCFsTY9gN9NDJLz1wYsjKjFbqBwGH61myZEfMvmbdvIDQuo4OYyMlmpHjQd8
Message-ID: <CAJfpegvB3At5Mm54eDuNVspuNtkhoJwPH+HcOCWm7j-CSQ1jbw@mail.gmail.com>
Subject: [GIT PULL] overlayfs update for 6.16
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/overlayfs/vfs.git
tags/ovl-update-6.16

- Fix a regression in getting the path of an open file (e.g.  in
/proc/PID/maps) for a nested overlayfs setup  (Andr=C3=A9 Almeida)

- The above fix contains a cast to non-const, which is not actually
needed.  So add the necessary helpers postfixed with _c that allow the
cast to be removed (touches vfs files but only in trivial ways)

- Support data-only layers and verity in a user namespace
(unprivileged composefs use case)

- Fix a gcc warning (Kees)

- Cleanups

Thanks,
Miklos

---
Andr=C3=A9 Almeida (1):
      ovl: Fix nested backing file paths

Kees Cook (1):
      ovl: Check for NULL d_inode() in ovl_dentry_upper()

Miklos Szeredi (4):
      ovl: make redirect/metacopy rejection consistent
      ovl: relax redirect/metacopy requirements for lower -> data redirect
      ovl: don't require "metacopy=3Don" for "verity"
      vfs: change 'struct file *' argument to 'const struct file *'
where possible

Thorsten Blum (4):
      ovl: Use str_on_off() helper in ovl_show_options()
      ovl: Replace offsetof() with struct_size() in ovl_cache_entry_new()
      ovl: Replace offsetof() with struct_size() in ovl_stack_free()
      ovl: Annotate struct ovl_entry with __counted_by()

---
 Documentation/filesystems/overlayfs.rst |  7 +++
 fs/file_table.c                         | 10 ++--
 fs/internal.h                           |  1 +
 fs/overlayfs/file.c                     |  4 +-
 fs/overlayfs/namei.c                    | 98 ++++++++++++++++++++---------=
----
 fs/overlayfs/ovl_entry.h                |  2 +-
 fs/overlayfs/params.c                   | 40 ++------------
 fs/overlayfs/readdir.c                  |  4 +-
 fs/overlayfs/util.c                     |  9 ++-
 include/linux/fs.h                      | 12 ++--
 10 files changed, 97 insertions(+), 90 deletions(-)
