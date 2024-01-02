Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2ECBD262
	for <linux-unionfs@vger.kernel.org>; Tue,  2 Jan 2024 10:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fC8sg9EU"
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-6dc64318b29so722266a34.1
        for <linux-unionfs@vger.kernel.org>; Tue, 02 Jan 2024 02:16:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704190575; x=1704795375; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zPecElPZ6J5KoEou187pLRnj0ZOpFlWslT6fWOlJBs8=;
        b=fC8sg9EUHy/lY5ZeWARJWJst8u3SmKQB1meZQdF2mexA7vxBYQBebBCSa0jejordRJ
         4c0+hqX1MMmpaWgcDh5bvmjxa37mSjmipSBqI/T8oY8KZBZE/0bmoH7v3FzqMY5kkPz/
         JVqjefrfSzBMkVfLqHqyjXMlyXCLIiL/ghKU22daR36cmrYw6/7MssyC/XjYpvaf/u7N
         oe2DqeesYUkhf7v8xuRpQ4HS9lcYFg1uKohE9qtFUTS5il3hqE92qOUswfQtX6HsBkxd
         LCXaQpeevQ17o6NLPX5oGClWi/8JA2gIqPFfZMpkjO0R6Zj6TmCL9VrIlx6QHtLVUI2V
         MwJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704190575; x=1704795375;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zPecElPZ6J5KoEou187pLRnj0ZOpFlWslT6fWOlJBs8=;
        b=QFi3t5Q6o5AktwdybbMv2uTM/HYx8WGGs75AWhVs73Dc1a3SF/d+B15UAvmalVnKw9
         NuHqwmftLrDo6gnbRLiejIv7iqgHiVvMrUiP7rxdGDf6OV3yeI44cj29gj3n754HW0jM
         X6S5XmJW4LvBi+R0ydhY2b5emBCQjRR6fgu0BohLzFLeW9I6iiMrlOBkVlv0Gok1CSNm
         Xo2V50ITCGgVToUvs5fZM+6wovJzYJUMESSa3o3B4Y5uC+GSYtKkXGUyXPqme6eqztUD
         av7eFlYzbxbDcNyADBbm9RoBht667xdhKvfZY95cr9tAnJW5W9cuEtGxPe56o1YxP/Vc
         JV1A==
X-Gm-Message-State: AOJu0YwMrGNKOgvwu+rNjXde4JnfL8Nhfb0trwGXrASP6APwZ/ugqVV6
	IN9j8/EROi33k/ZLSFZKnsOM6IbMZODnEwfacnvLn+2Wr/c=
X-Google-Smtp-Source: AGHT+IGrCwmyVKDrLrudXbRXBIXMbolcw1XNlMiAarFLI+gUVQlcqZ21UHYfxbHyzjdRMMi0O7LlGmcdkGJzy+bwPiw=
X-Received: by 2002:a05:6358:914d:b0:175:16f5:a861 with SMTP id
 r13-20020a056358914d00b0017516f5a861mr5142305rwr.50.1704190575543; Tue, 02
 Jan 2024 02:16:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Sender: shanthosh.rk@gmail.com
X-Google-Sender-Delegation: shanthosh.rk@gmail.com
From: shanthosh krishna moorthy <santy.accet@gmail.com>
Date: Tue, 2 Jan 2024 15:46:04 +0530
X-Google-Sender-Auth: nf0iXKu-jAKOboN1M_D3aKiL1Ok
Message-ID: <CAPPzL72iBRiUcaL8P=NQ+kMxpDW+4A5bbPku==Z+TitdbN31pg@mail.gmail.com>
Subject: reg: Stacked overlay support in Linux
To: linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

Is the Linux support for mounting overlay file system over another
overlayfs lowerdir still supported?
In kernel 4.1, this seems supported but not in 4.19 and above.

//Create lower directoy on an overlayfs mount
root@device2:/# mkdir /lower /upper /work /merged

//User the 'lower' directory as lowerdir in overlayfs mount
root@device2:/# mount -t overlay overlay -o
lowerdir=/lower,upperdir=/upper,workdir=/work /merged
mount: /merged: wrong fs type, bad option, bad superblock on overlay,
missing codepage or helper program, or other error.

root@device2:/# mount
...
/dev/mmcblk0p9 on /overlay type ext4 (rw,noatime,nodelalloc,data=journal)
overlayfs:/overlay on / type overlay
(rw,noatime,lowerdir=/,upperdir=/overlay/bank_1,workdir=/overlay/work)
...
root@device2:/#

Could someone please shed some light on this error.

Regards,
Santosh
