Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0449D6BFC0;
	Fri, 27 Sep 2024 07:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727421006; cv=none; b=jh4kDow7LKEJgYmR+vs0koXdqCZZFFulKL9jeibnjaXKrImLh7sOO0XN9Mwl6ysd/S5iEAw2KWHP5wm7und+uPEUKRNM0yW9v25x8+u0VXFmGU87cem0LO1sRncUSu+nxV9H0Oc2NEw+EaP6C2rrHC0ZH9nOlH4WIJth9sy8CwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727421006; c=relaxed/simple;
	bh=nrXyo6rSalrxDvu3KKVPOyZfO9gws1fSAJz6QSH0iQs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Mjf0iSEfFizJWy0qqZ6W9c1soxSia74cIfLfgyuJOUoa72k4U4Y4/1yQFpsqeW8lsZ2yp78aHS5itDnxuXG9fE7PMQmAb4SPqdFN9ExfmdJA2bLCQJyvsTcng/Sk529vn2QLBgXmAD3WoTjBXb1yUYnZNbi39TUAUudGNZ4nkzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Iasi0Lks; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Iasi0Lks"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-7db54269325so1364001a12.2;
        Fri, 27 Sep 2024 00:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727421004; x=1728025804; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=n2SdVCFe+c85mj/Vz3aROtTmPOFVP1yeKdmNkgMPZAg=;
        b=Iasi0LksDLaasTT9My7649DysZgcCuwArTak6w+Zhc+Ke+7Vc/7WdMDDMoZU8tp9z8
         3xHRfF4qOb3m5TYMzRUo0oQkV3RrgRi5rOa+tWzd8iyCfAm8k4SwiIBlATY45+ZPnd9i
         nSJNjK/1hrnrV09t7D0su8XyrM9CCuck0BvFGSzJG/VT/+3xeyegWD6XbU1sd1BYzF3y
         QYg06C2cvdq6ANfv/iXSDo5BRQlWrls90EQ6P8bjJowxU1pBLYLJXxWs/jZkp8BU3Ow4
         3x+gQI59bfRljhkL/lW2PGkDTGkdS1MuVSY5A1j5g2Yn36t2PjskDucPd8+EmJzYMoXA
         Y/AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727421004; x=1728025804;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n2SdVCFe+c85mj/Vz3aROtTmPOFVP1yeKdmNkgMPZAg=;
        b=A71j6cRRr2cU6TCO/lgYT3hi4Cl4P/iVmFEaNubLiLBTJj3hrtnNthXWpzcl9oiNmo
         n4lufmNHR80WdXN/7xrbqOw29xkxy7t4o3/A/6XEagR7Qj4QK2LGSODeK+vcI6plj7RQ
         2h4qnHcgdgrEfVdEo7Q0uXxUXh67vb5PJxk9MqEvm3DTHlfRT30FY0SFLyFZlfsjJmMu
         p5bbD79fXemwQmZdi6VeGdVvQ5zVdntimRkghJvHuW0T59X5d7k5wp+oNafDA+RZg7CO
         BakCxkJ7R2aCD9IpOh/ug2pyEzQvQz6waKmG6DdujOVdI5ioVRKErE85O7f2yVLamDZz
         g4Pw==
X-Forwarded-Encrypted: i=1; AJvYcCUWDPfu4qoaLhpeR31AiQYzQpmF8MuyqVnYUKyVN1srnfHwBGc9FviuOTiG5BNAB5YUkHY8lgAMfc9QiGCRIw==@vger.kernel.org, AJvYcCXgNzxd7aiEyjKC9+0snRF3h4+7vt1FEdsUHTDR3hIDCnEfCXLRaxouTCEoIbl2QBoaTxFiFxaTO2oleXo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxp1EeVeyecWaTatpvzUwBxFjbbXMaf9kUJemKt0EVm8AizDBk2
	qOuw5TN/9Gk/2qabXh8bddiSAXnUkoGSy1km4zo0uEFSRzSlAjDW
X-Google-Smtp-Source: AGHT+IGYJhGARPKzg8Aet9OB2o+cMNQ0PO9cT7AF/MR3oO7a9i67dTHoWF3QhT0hYbV2hY24d0cYcg==
X-Received: by 2002:a05:6a20:c702:b0:1cf:3e99:d7a7 with SMTP id adf61e73a8af0-1d4fa677f59mr3979228637.12.1727421004076;
        Fri, 27 Sep 2024 00:10:04 -0700 (PDT)
Received: from tc (c-67-171-216-181.hsd1.or.comcast.net. [67.171.216.181])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7e6db2b2f73sm965187a12.25.2024.09.27.00.10.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Sep 2024 00:10:03 -0700 (PDT)
Date: Fri, 27 Sep 2024 00:10:02 -0700
From: Leo Stone <leocstone@gmail.com>
To: syzbot+d9efec94dcbfa0de1c07@syzkaller.appspotmail.com
Cc: amir73il@gmail.com, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, miklos@szeredi.hu, syzkaller-bugs@googlegroups.com, 
	skhan@linuxfoundation.org, anupnewsmail@gmail.com
Subject: Re: [syzbot] [overlayfs?] general protection fault in ovl_llseek
Message-ID: <k53rd76iiguxb6prfmkqfnlfmkjjdzjvzc6uo7eppjc2t4ssdf@2q7pmj7sstml>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Add a check to avoid using an invalid pointer if ovl_open_realfile fails.

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 2b7a5a3a7a2f..67f75eeb1e51 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -117,7 +117,11 @@ static int ovl_real_fdget_meta(const struct file *file, struct fd *real,
                struct file *f = ovl_open_realfile(file, &realpath);
                if (IS_ERR(f))
                        return PTR_ERR(f);
-               real->word = (unsigned long)ovl_open_realfile(file, &realpath) | FDPUT_FPUT;
+               f = ovl_open_realfile(file, &realpath);
+               if (IS_ERR(f))
+                       return PTR_ERR(f);
+               real->word = (unsigned long)f;
+               real->word |= FDPUT_FPUT;
                return 0;
        }


