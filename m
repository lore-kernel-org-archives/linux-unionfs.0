Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kfACBcOY"
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D3FEA4;
	Wed, 13 Dec 2023 04:34:28 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-40c2bb872e2so64129345e9.3;
        Wed, 13 Dec 2023 04:34:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702470866; x=1703075666; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gJkAH+PEEHeF2/e1GKoZROvDjNrDXfi188/DWZu55X0=;
        b=kfACBcOY+m3ZACAGoZZEWUBMMbxX0H0trOjlIGIKgFuFF7W2TBEjI339FYo15bWTsF
         RRfKIaLM0xYJWCHQz9sIKxpsn9H06JhigQh8LXenis8g6v6QPoWxjkT4eHQXQA/4REsm
         pVZnoKxhrWy7JvccnFQsTuMZSKufrpn6tWimcmREBvBz7YUgLIbVQHaBgNuiPXUFJuvn
         OrRswFgevBBNn6NX+cQ4Uz/YM5+ZqeSLd4HMpu+p4AfEtjs9AX4H3h0LvEGTIjjfM/ie
         DisDWZ0RW4ZQVn+DsOYcJFaKTL9tAlzmihi4tBeTWXlQlqVkfEzoBk3k25vo23qDFz+v
         tRcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702470866; x=1703075666;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gJkAH+PEEHeF2/e1GKoZROvDjNrDXfi188/DWZu55X0=;
        b=ZbrNPsUyVNgU4qrxDEJR9+HnJ0+/7I3KeGvligunZrQsHcpeZ/4ve8N0I4lL5T1Pn7
         fTHEWOOefBAgEJmOaL7+2nlWHKiBVUVCRlGqatRjeFPLekGtf48JreId2NkL/8o/VykQ
         lpdeJU1O8ccRgVQ/jVM51+HhdH2DSKhK7rPnG8mZSgaatHi2OZpunEStDgBuZyFLPnri
         2IlXcwJkfJAOLbQTq0e7UCH/dvMgrSTWKe+ODDGg/AN5q7R1q2NrvPlGAU6FuYlrkbVc
         ZXNmR5Vw2t6jFwKb78HhVw0ouXu4dMGvYoGJfRREDl/K389eco+Qj6c2FyztMRKYp0i2
         QQMQ==
X-Gm-Message-State: AOJu0YyhFCGZSFd1YV9EZtwF5zqZb0t8sMg1+A7g7VBDmM6mXQS8/Z1C
	mgvb/UQVabWCKl+BC3kkodo=
X-Google-Smtp-Source: AGHT+IE3XttQN68XC/wZPDRsd1Zvr8bH0pvpwzVR83cB8Ma/IAroH3+r/3R8kXKk10Gwna/GQ4CbgA==
X-Received: by 2002:a05:600c:2289:b0:40b:5f03:b3a8 with SMTP id 9-20020a05600c228900b0040b5f03b3a8mr1906077wmf.202.1702470866186;
        Wed, 13 Dec 2023 04:34:26 -0800 (PST)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id fc7-20020a05600c524700b0040c44cb251dsm12667926wmb.46.2023.12.13.04.34.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Dec 2023 04:34:25 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Christian Brauner <brauner@kernel.org>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	linux-unionfs@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: [PATCH v2 0/2] Fixes to overlayfs documentation
Date: Wed, 13 Dec 2023 14:34:20 +0200
Message-Id: <20231213123422.344600-1-amir73il@gmail.com>
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
  overlayfs.rst: use consistent feature names
  overlayfs.rst: fix ReST formatting

 Documentation/filesystems/overlayfs.rst | 90 +++++++++++++------------
 1 file changed, 47 insertions(+), 43 deletions(-)

-- 
2.34.1

