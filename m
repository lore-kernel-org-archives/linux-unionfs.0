Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aNhE83+1"
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 640C2AB;
	Mon, 11 Dec 2023 23:33:29 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id 5b1f17b1804b1-40c317723a8so44127965e9.3;
        Mon, 11 Dec 2023 23:33:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702366408; x=1702971208; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QX+eMO6KAbIijZkmt7rRkpPO9V/cevryyn3HOI9EI68=;
        b=aNhE83+1m0GNZquqMKK0L9C8QrWMYLyFyFbUwtvNwWcS0lDWOsXiIGYChmbs5pKAG3
         vmQlO5gEaWMPgk1jrR9+VZmZzshxuevUYabfkdPCgczxPBOE9CermzNJFN+burBb/Jh5
         p25U9fmjIt8FqlSaGwU1dJOc7SHXXE5uwWCdzKSsckPLbERDkniOg430MynlFt1kbcb2
         yCRptPoV+9NyILYhZ5BzA4j1FXnZLzTfj3uzYDqGL9MFcvA97E817gdYKwjgONQ1C01y
         jUDOFB4jpfjThj1b+m5sfY08VE313pleUuhwGcjs37d6j2Uk4A164IE5scCQkFegC8Tp
         Lwgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702366408; x=1702971208;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QX+eMO6KAbIijZkmt7rRkpPO9V/cevryyn3HOI9EI68=;
        b=kSDZB0WjNXicKMVnHPmiA5gzdGIaoL+7VwFygSI+Z3AIahZ/DVkyOWC400HSbB9LB5
         OTV5JbMiIcljFvMHw3V/YTzKofgRtoHfcDjSrnM/kW+tHTXBCBdtZL/Awm4X7Kf0kZKP
         LnZJXnyMQEXAg8HnWY/pTFg+SOjlHwh4M6RZH7tHzqnKthKBkgcZB8BKmofdLniY2One
         oEw95lKScSt1NJYxLmAH7GYBdfm2dpbT8sQB0/Dm/NKaVQq2Oswr8PGLXaUPqjT+SSOp
         B3O3n5uZmLycfK6P0q65ewYRLKEN7q9gbQeWbseU8ESpg6PrWb/bLOOFIgzSLGduSRgn
         oCcw==
X-Gm-Message-State: AOJu0YztCidU1zw177mrxrOc16Ec+SbyEVPggH4qBuiaazCduaTeJiJC
	e/+7vPZWwAMprc5euZd09WcxHygssew=
X-Google-Smtp-Source: AGHT+IE/QqXpYmt2xbLdsLGydca9PpPpPReZcClFk2bSGISSzwGmfR5LQA4ZABQ2+H7Sqm1A5F4Nrg==
X-Received: by 2002:a05:600c:3107:b0:40c:29fb:2c4b with SMTP id g7-20020a05600c310700b0040c29fb2c4bmr2925306wmo.148.1702366407572;
        Mon, 11 Dec 2023 23:33:27 -0800 (PST)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id l15-20020a05600c1d0f00b003feae747ff2sm17896319wms.35.2023.12.11.23.33.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Dec 2023 23:33:27 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Christian Brauner <brauner@kernel.org>,
	linux-unionfs@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: [PATCH 0/2] Fixes to overlayfs documentation
Date: Tue, 12 Dec 2023 09:33:22 +0200
Message-Id: <20231212073324.245541-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

Some minor fixes to overlayfs.rst that I plan to queue for next merge
window.

Some of the fixes are workarounds for oddities of github when parsing
ReST format [1].

Amir.

[1] https://github.com/torvalds/linux/blob/master/Documentation/filesystems/overlayfs.rst#permission-model

Amir Goldstein (2):
  overlayfs.rst: use consistent terminology
  overlayfs.rst: fix ReST formatting

 Documentation/filesystems/overlayfs.rst | 96 +++++++++++++------------
 1 file changed, 50 insertions(+), 46 deletions(-)

-- 
2.34.1

