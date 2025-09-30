Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF251A239A
	for <linux-unionfs@vger.kernel.org>; Tue, 30 Sep 2025 07:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759219130; cv=none; b=rVoAba3NsBLDF7q5upsMc0gmQq4MLXfU4Fycu/sGFakTrZvYrrRZvBqomW431lWWXWxC8Xc7eQeD904gmFr1JWp0OwWrvLnFaog8iU98OjPAMRlVG6AHYSkcdZXvtgiqUQR2WulUqqeB2GE0tDLcc2PgF4z3ZeGqdRTjojQDJcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759219130; c=relaxed/simple;
	bh=GW0+t7xjQhqLAlZvuCH2wFM1HzLxDXq+6ZhGCWe3SNs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Y251rgh4srlaJ0KwOjs2wgiKYFTv6lXEWINp9u+VZLjl/uUXAjjO/RWRLAV1hYBhSdwsK5+9UN1vSdsuaOEUUV4ud6SkEvvb7IHF2MOvkmLDuCDPmPO3ZfN7T/cK04DtmdxSbtgdtJrUKtAEZHp0IxEvaLujSmO9KXw4/1IAnSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dklnDDVg; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dklnDDVg"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-afcb7a16441so915755966b.2
        for <linux-unionfs@vger.kernel.org>; Tue, 30 Sep 2025 00:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759219127; x=1759823927; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tdLjLEy0U0fuaZSofLkGJRFfTbY7z9ZRmrdaFEYCljA=;
        b=dklnDDVgYKA85Rr7+3/jwHGln3VPS0ttkTDCk27L66JX5qndCzYAXP6de+DxZz+9l5
         QJShijegUtztNrDYHVfbCMjUAy1aT92iyC1/V6BW7s08QXu4xfspPl74LYsMGkk11MFH
         +vxJxixnaXVpOfxl5dvrMSCoaKE5qO4ek6htQ5lT5zvxLuAlMMCQPajAP7fcqzPEgqHy
         2ghC1WEuu8/tUp5TjsAN30IosSxh7JiskKjNWK6ERuG5fYrX2bDbI4ANWZ7jZO76HN1h
         xYdLEFNCG07EEjsCwDrEU6YekH5AwAjmTADNfJSZhCd/LEOwnG/MMhqmCUefftGHOmBv
         pArQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759219127; x=1759823927;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tdLjLEy0U0fuaZSofLkGJRFfTbY7z9ZRmrdaFEYCljA=;
        b=A36j0C62aNujpFRXd58eIWrLmb/l3WjPYYXKU9xxme4xUvBfvZVIgIpjkPozJUQvbL
         ef0SgAHxWuveMCTrKm3ouIDjGkZ9AYq/Y4E+7LzMw5db9VZTBQyPLnXKPofNgv1ruW5C
         rjX/RBPftqwUhbPXWdFQk8R8hWcn1/7PvmL1lFou3EtFC47ubDHeXilwRJzMGqVc60kz
         5TdWN6d/77/ny0CnPnZnh3bvtft5CqKPv1OUM4xXS2w9czq7H6gnxjLqvNk3uO6kMUBj
         HeKFdWvLkh/nOuwKV9TTkItwDsjUBz4t4sKFdDOzXiY0a9eEqFdaJuZ7TVh4HnFrJpRd
         8hNQ==
X-Forwarded-Encrypted: i=1; AJvYcCWqzQyiUG1mlW8C7ixB8YCFvlyoZbE1E7wZnaKOFxwMYiI9+TT57+Fbn5Pj3miut9yqwch5k0lC9vXBGtmn@vger.kernel.org
X-Gm-Message-State: AOJu0Yyq+JE12tZTjzLsuPCRxtqfXYaE56vDOOsWcr/YRJ87y0NHg0TX
	OSJbyE409ca42Rf/YS3X3d4flTyXpQdHpYWaEhJgTbPg9F/Lcy5FgZoI
X-Gm-Gg: ASbGncuhEhvCbPaxuNRG5diNFVkFe59o3HiXjqaDw0ufleLt2OkwQ7XBHVT3vtDPJEh
	Ym4lf++Rc2SFsXROockeoxse5TArnKwWUWqMqpwx8bxE3a1cWDStKNylsonSXLAvS2wu1EacXys
	p+6flUe5wpHJAZg/q/HEXCLLJitEY6PxPqZc4bfoYd/BIYeLIDxJ5gIdj7Q2mBuHoYHXYjStU8q
	Ii2LYrxzKzQ5fA0Nx/+66Cr3x0xCH/gaQj3OjayX9YYXAfVbOWKVfneMBWYG1t5rwWXn6muOPt3
	vb3gfTRrIWixA+HiI7ITm1/jubQm+/oKrMkKHemRfrITV5v9ErI7EqUkfayEamzbCblDTqS0NAI
	ZZ6C8DWq5Utw8mixLeWndYuKdVC1m0NT1vx6BbdP3q73PUqVq1HK1SdIzRdwv+c9S0GNvW1l4nz
	b8AGHmb8PN1VxfMsioBu8Os3op2M5dRBVUzl0aYqRVhyXiLEc3oSiKXxoRi//MWIEoc/m3Rjn0E
	LHV
X-Google-Smtp-Source: AGHT+IG74fN0DIkyOhjohxH9Y+ip3FELgnzPQxo8Ns4r1Man0mPD+YCE6s+wO1i6xseHx0QHtnzQkA==
X-Received: by 2002:a17:906:f5a3:b0:b3e:e16a:8ce4 with SMTP id a640c23a62f3a-b3ee18913d0mr757795866b.3.1759219126556;
        Tue, 30 Sep 2025 00:58:46 -0700 (PDT)
Received: from amir-ThinkPad-T480.ctera.local (2001-1c00-570d-ee00-b818-b60f-e9a4-67a5.cable.dynamic.v6.ziggo.nl. [2001:1c00:570d:ee00:b818:b60f:e9a4:67a5])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b37b3b46ba0sm905613366b.2.2025.09.30.00.58.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Sep 2025 00:58:46 -0700 (PDT)
From: Amir Goldstein <amir73il@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Christian Brauner <brauner@kernel.org>,
	=?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@igalia.com>,
	Gabriel Krisman Bertazi <gabriel@krisman.be>,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-unionfs@vger.kernel.org
Subject: [GIT PULL] overlayfs updates for 6.18
Date: Tue, 30 Sep 2025 09:57:38 +0200
Message-ID: <20250930075738.731439-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=true
Content-Transfer-Encoding: 8bit

Hi Linus,

Please pull overlayfs updates for 6.18.

This branch has been sitting in linux-next for a few weeks,
but I added some RVB last week.

It has gone through the usual overlayfs test routines.

The branch merges cleanly with master branch of the moment.

Note that there is a small change to fs.h in this PR for the
sb encoding helpers.

This change is reviewed by Gabriel and Christian has agreed that I will
merge it through the ovl tree.

Thanks,
Amir.

----------------------------------------------------------------
The following changes since commit 1b237f190eb3d36f52dffe07a40b5eb210280e00:

  Linux 6.17-rc3 (2025-08-24 12:04:12 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/overlayfs/vfs.git ovl-update-6.18

for you to fetch changes up to ad1423922781e6552f18d055a5742b1cff018cdc:

  ovl: make sure that ovl_create_real() returns a hashed dentry (2025-09-23 12:29:36 +0200)

----------------------------------------------------------------
overlayfs updates for 6.18

- Work by André Almeida to support case-insensitive overlayfs

  Underlying case-insensitive filesystems casefolding is per directory,
  but for overlayfs it is all-or-nothing.  It supports layers where
  all directories are casefolded (with same encoding) or layers where
  no directories are casefolded.

- A fix for a "bug" in Neil's ovl directory lock changes,
  which only manifested itself with casefold enabled layers
  which may return an unhashed negative dentry from lookup.

----------------------------------------------------------------
Amir Goldstein (1):
      ovl: make sure that ovl_create_real() returns a hashed dentry

André Almeida (9):
      fs: Create sb_encoding() helper
      fs: Create sb_same_encoding() helper
      ovl: Prepare for mounting case-insensitive enabled layers
      ovl: Create ovl_casefold() to support casefolded strncmp()
      ovl: Ensure that all layers have the same encoding
      ovl: Set case-insensitive dentry operations for ovl sb
      ovl: Add S_CASEFOLD as part of the inode flag to be copied
      ovl: Check for casefold consistency when creating new dentries
      ovl: Support mounting case-insensitive enabled layers

 fs/overlayfs/copy_up.c   |   2 +-
 fs/overlayfs/dir.c       |  29 ++++++++++-
 fs/overlayfs/inode.c     |   1 +
 fs/overlayfs/namei.c     |  17 ++++---
 fs/overlayfs/overlayfs.h |   8 +--
 fs/overlayfs/ovl_entry.h |   1 +
 fs/overlayfs/params.c    |  15 ++++--
 fs/overlayfs/params.h    |   1 +
 fs/overlayfs/readdir.c   | 126 +++++++++++++++++++++++++++++++++++++++--------
 fs/overlayfs/super.c     |  64 +++++++++++++++++++++++-
 fs/overlayfs/util.c      |   6 +--
 include/linux/fs.h       |  27 +++++++++-
 12 files changed, 254 insertions(+), 43 deletions(-)
