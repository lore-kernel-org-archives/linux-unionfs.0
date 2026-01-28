Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5973D350D79
	for <linux-unionfs@vger.kernel.org>; Wed, 28 Jan 2026 13:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769606650; cv=none; b=Tc/RHFKwToORMn7hgCL4z7zaMTRw5a0oBjc29+Zsq1qzHNAJAfc4uMorb3qJHh0D9UcAvAzThR78wLgY2IJVBdODkfd/Htx1dFOqS3Nq3vUdXVhUfROPH1n6DeHCmE+EMgdwj4vs6aNKz8KSb6070/anZVJA65dWxyhMQ6/P3Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769606650; c=relaxed/simple;
	bh=5mj9f+jiqWsP8JUwxAFNqRoV0N/RWg4pBZ79Q5rxyLU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IAjCMiqvUR+7WO4/cpM+ygFDlwa7u0R7jYGHeXGLAsAAKazZgYk3F0cJv7Gv7AMDUPjFYFD1ePe2GX6CPDSTWZ18UPKS7WipS8JDMawCF5UeWe60YLVQOuyKmXVpJHOg+PkJNYEqRHFboZ4x35u23faanaTJOT8kEXJha4VZ21s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gchs8YhE; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gchs8YhE"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-65832e566edso9841177a12.2
        for <linux-unionfs@vger.kernel.org>; Wed, 28 Jan 2026 05:24:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769606648; x=1770211448; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2C0U7hvt67M0jhge/Mq6BbLukFcgthoPBAq2udkVqlA=;
        b=Gchs8YhEuiqjm7UISgnUjThDUVDjst+urDIUMDvEB+B31Ai5cUSrRb3Qd2uWZnojlA
         jE+uY/UYXdxaPhQKj/vTQbpygTlD6GYbeszZyAkIXsAVkFM5/Ludp+69wuF/CPmwGDIn
         9wcjCFDjXBrziTjElQLGG3RzWEsLb2yFOUPYOAWyEUQzyUQy0Op9Rc7Fk+TXyO4mtgPK
         6jcVnDRPs5m5BO9Fylo0AQQKDS6x40LuSQ2PN7p6JI4w/1QjvWFydOFjAP7Jh8RFkX5H
         Alb/TM8kxyD3Nhr402gfxfnZpwW5YN9Xmx04SRjjheRMSckdoA/tyQZrWuIZ3B2Q+sDn
         NWzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769606648; x=1770211448;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2C0U7hvt67M0jhge/Mq6BbLukFcgthoPBAq2udkVqlA=;
        b=EHP51/CqlYueovZ8lRS93fqjQVOUZ64XtZ4Tx7fTa6OnvnikQocmJ6ANcmi9I404pf
         kL4X3xrpQaDAi3kWcprP87eePmK+VrN9pWbRtvGyzjmEpVX+S7NifimfA9EQAyXMZ2IA
         yL9nhbKVr+Ap9P0hN8hYybLmaPrQxz+3GHAeBM6mTj6bDpkoJ0OF3F8E5yAEzBAXItwv
         7BcobvUpzFfXRifzHYF1wV2pX7M4mWHdsnIVF0wASC6a8DzFwUv2FIXMHMYlEQMx/LoK
         TAZb8rvem90PSGL2OzgAtZLQiUegGr02ZjzMgiFZZM8ltfbJGnyILnooQvhZpmPu/Mii
         6c9g==
X-Forwarded-Encrypted: i=1; AJvYcCXYFTt8lPy/6uUqqVP77UjuJ0H2tuKjJS8cKrmm8JY2zsev65JYSto75u+jdmzfxRiy7KfDqp2T1aOWIotU@vger.kernel.org
X-Gm-Message-State: AOJu0YzgCT2aosCcdzy3Hka4Nm/ut7tfo+ekKIIvP2V9wfjI2UKbbdFD
	d1yQ5n3V3J7935UWAn34g8ZFfg+bU2Xl1m2ivzH5A5Eda6S25MCfLuuy
X-Gm-Gg: AZuq6aIaZQKhj5gtxwYW8OzErzCTqyFe33FhBEGMtbtpxhyijwrJvKRY5lVjH+vYfRR
	Ah9NwMITVUrihPvOGj8l5HoITufVhI82UnZIAtVfgGeRD8HxJV9F/XZYcxe2TV591m6h7OrFfYU
	IDACyO4rVwpDC6Wt3upyeKXg5cSOa2Cd33zpYYqrB0zELPyEfEluBqBnVMiQ9/QSTgBHfbZNQGO
	LUUfE6s1raeI27wWtHKswna8Jw/mFO3ZFEOwLBF9E+fYz6pvUmr6vqR7HJ7tPZEbyma1pf+yTIS
	eEBkdq6w8fm+YwTQzgX+Uxfh32k2nD4Fkx7ah9cmHsxQDrbOXJgRh9KtiShphK/ZeCXK0r1ElHh
	vzAT6MPporWa9Qh3YzTOKMGBqwQjv5Oc2vZiEQN3gxr7KECW0Je0V+iMgTJi6xIxrk+9OrYpjFS
	6cAAKWUUwjEwbYFlYKHlUQK/L/YAgAhzoPb89dxN6jQ5KXOgCqAjnqeERieeXRI2lpMds97XsA7
	51NfxyemgvQKWBW
X-Received: by 2002:a05:6402:430a:b0:658:b922:22e0 with SMTP id 4fb4d7f45d1cf-658b922246emr1251224a12.28.1769606647432;
        Wed, 28 Jan 2026 05:24:07 -0800 (PST)
Received: from localhost (2001-1c00-570d-ee00-c84e-f30e-bdab-df5a.cable.dynamic.v6.ziggo.nl. [2001:1c00:570d:ee00:c84e:f30e:bdab:df5a])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-658b4691d0asm1545885a12.18.2026.01.28.05.24.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 05:24:06 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>,
	Christian Brauner <brauner@kernel.org>
Cc: Qing Wang <wangqing7171@gmail.com>,
	linux-fsdevel@vger.kernel.org,
	linux-unionfs@vger.kernel.org
Subject: [PATCH 0/3] name_is_dot* cleanup
Date: Wed, 28 Jan 2026 14:24:03 +0100
Message-ID: <20260128132406.23768-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Miklos,

Following the syzbot ovl bug report and a fix by Qing Wang,
I decided to follow up with a small vfs cleanup of some
open coded version of checking "." and ".." name in readdir.

The fix patch is applied at the start of this cleanup series to allow
for easy backporting, but it is not an urgent fix so I don't think
there is a need to fast track it.

Christian,

I am assuming that you would want to take the vfs cleanup
via your tree, so might as well take the ovl adjacent patches
with it.

If you want me to drive this entire series via ovl tree, please
ack the vfs cleanup patch.

Thanks,
Amir.

[1] https://lore.kernel.org/linux-unionfs/20260127105248.1485922-1-wangqing7171@gmail.com/

Amir Goldstein (2):
  fs: add helpers name_is_dot{,dot,_dotdot}
  ovl: use name_is_dot* helpers in readdir code

Qing Wang (1):
  ovl: Fix uninit-value in ovl_fill_real

 fs/crypto/fname.c      |  2 +-
 fs/ecryptfs/crypto.c   |  2 +-
 fs/exportfs/expfs.c    |  3 ++-
 fs/f2fs/dir.c          |  2 +-
 fs/f2fs/hash.c         |  2 +-
 fs/namei.c             |  2 +-
 fs/overlayfs/readdir.c | 39 +++++++++++++++------------------------
 fs/smb/server/vfs.c    |  2 +-
 include/linux/fs.h     | 14 ++++++++++++--
 9 files changed, 35 insertions(+), 33 deletions(-)

-- 
2.52.0

