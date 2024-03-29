Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A3585633
	for <linux-unionfs@vger.kernel.org>; Fri, 29 Mar 2024 01:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711677304; cv=none; b=UX68hVPrjUIqmyKnmLP7tH5KJGvb0MQE2Nu++l2eqUGDfz30VI6cw+XIBgR+9BGdALdp9CBNZDPCpzqqF5Z219xcCtWxMRCHhZwR0j2JsK5df+FXar7wCuLvqjJVLPSe/eqMTOGLpeQ+Ydb1yV5aioxoiwqF0Z8uoIP4SZIiiQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711677304; c=relaxed/simple;
	bh=KCoIZNUHcwv2RV9ZRbHBJii4HaQ9xYYtK2VIovQhTY4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OiI32WfVeZHzQpcxjF7Wa5kpK/RAsffHUsBWqTIR6Wi5x2rAlb2MvmlB9lyjqEzSc6VfJTJA6a7rSyX5Z1xpu1kaUP1MY0PW4DGi7hYeh7xjVPhNhhg2ZJEM/d8ILt9FJ5RnfWGDCqBLol6WvxI9u+sqHf1SiLbXho8UpQFzemw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--drosen.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cGvlUFtl; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--drosen.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cGvlUFtl"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-60a2386e932so29402067b3.1
        for <linux-unionfs@vger.kernel.org>; Thu, 28 Mar 2024 18:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711677301; x=1712282101; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/G940zvh+KpSLBvufKEbVa5uESG7TAs31JyWujh5JiA=;
        b=cGvlUFtlWGRTPkcyYNCMwvSxvP8qlwrZr3JOFvlMOAHhswasUvQzmPZLlH01AY8Kke
         CDnQgoMEJhPRIKJsyS04oYc8Uuu55Dzdh5jmQyxNhfsUDMZZEkM1xiv1h5HuuzYlN6zl
         PODUMjxw8QyB8/DxnT+YoKR3DI/rJSNob2BNPMMEmg+Bogh048li815kIsg18b85Utld
         Iymm98q4jMGrSCjfKBjmefZPnJZpcMtoplmG+B4yi7PxdPAoPOD9gEgZgZCkQSQESDHb
         zNE7xCcmRxlLfrm4sMPXWZKy3jJxhIq7sq9SCl2/E0a/qS5mSG6DsrzM9EQEaQppU9Hb
         4vfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711677301; x=1712282101;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/G940zvh+KpSLBvufKEbVa5uESG7TAs31JyWujh5JiA=;
        b=a0iuOTnXgaYijcOZfFqOqJbFnBs3TFM+Ru1LMRJnFbvtwedvTPyFfyOubZyilnuVNc
         DgAiltYRpY7SmZo5GpSE4k+hlMGN45kbkNP0Qanf/jnjQ17oDWWI3ouqJKtoyzXJifJP
         nL9Zde4i47cKsgjpYDDk/4Jy4ND7FgKru/p/jtxm5muHHbBBJUVuChRr08svnjLph+Sz
         1TPGcV1Q/M7d4KSXmy6/4iiZuCycvz552HLycAdQgFmM0OEWOvct9yhzFTYG2o6HPz1Q
         gqaBzlnqet5fGgxkLNpjVPt9A1ZzfEsj7a7NzLnx7/7AQPRejVUdXufEEx4SdBrCs1ln
         sMIw==
X-Forwarded-Encrypted: i=1; AJvYcCVyCf5iUKuxmT9u19D9RQoMjUQB/yZ9a44ACKYbQ4Pw0AEJJKl5wY4tmPlm5QCx8EbUfI2p5xyzErkYKiVvD+cZnFnQ42zzLSinldwlFw==
X-Gm-Message-State: AOJu0YxdCjxIS63mHI9r4pYVnMbVCb2etXxaKAZXc1wrmCnk0s9jwn2g
	cVmDUiaeT5f4gFOwtr67Dmsuk5/MuCzFQLfM4J1irO+sMr6uGzXqkbIN03LGym86FXtMod0ozEX
	cMw==
X-Google-Smtp-Source: AGHT+IGsCzOtwN105f/bltaErVUfpSBRC3F9RkDjk/0Wfd4wmn+phWiKkcXdiSoxa6ZQkSCXtl1Jd331NFw=
X-Received: from drosen.mtv.corp.google.com ([2620:15c:211:201:fcce:d6ab:804c:b94b])
 (user=drosen job=sendgmr) by 2002:a0d:d8c5:0:b0:614:4c1:c8d with SMTP id
 a188-20020a0dd8c5000000b0061404c10c8dmr308593ywe.6.1711677300998; Thu, 28 Mar
 2024 18:55:00 -0700 (PDT)
Date: Thu, 28 Mar 2024 18:53:42 -0700
In-Reply-To: <20240329015351.624249-1-drosen@google.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240329015351.624249-1-drosen@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240329015351.624249-28-drosen@google.com>
Subject: [RFC PATCH v4 27/36] fuse-bpf: Export Functions
From: Daniel Rosenberg <drosen@google.com>
To: Miklos Szeredi <miklos@szeredi.hu>, bpf@vger.kernel.org, 
	Alexei Starovoitov <ast@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	Daniel Borkmann <daniel@iogearbox.net>, John Fastabend <john.fastabend@gmail.com>, 
	Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Eduard Zingerman <eddyz87@gmail.com>, Yonghong Song <yonghong.song@linux.dev>, 
	KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@google.com>, Hao Luo <haoluo@google.com>, 
	Jiri Olsa <jolsa@kernel.org>, Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Joanne Koong <joannelkoong@gmail.com>, Mykola Lysenko <mykolal@fb.com>, 
	Christian Brauner <brauner@kernel.org>, kernel-team@android.com, 
	Daniel Rosenberg <drosen@google.com>
Content-Type: text/plain; charset="UTF-8"

These functions needed to be exported to build fuse as a module

Signed-off-by: Daniel Rosenberg <drosen@google.com>
---
 kernel/bpf/bpf_struct_ops.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
index 43356faaa057..ae76b99c07c1 100644
--- a/kernel/bpf/bpf_struct_ops.c
+++ b/kernel/bpf/bpf_struct_ops.c
@@ -1024,6 +1024,7 @@ bool bpf_struct_ops_get(const void *kdata)
 	map = __bpf_map_inc_not_zero(&st_map->map, false);
 	return !IS_ERR(map);
 }
+EXPORT_SYMBOL_GPL(bpf_struct_ops_get);
 
 void bpf_struct_ops_put(const void *kdata)
 {
@@ -1035,6 +1036,7 @@ void bpf_struct_ops_put(const void *kdata)
 
 	bpf_map_put(&st_map->map);
 }
+EXPORT_SYMBOL_GPL(bpf_struct_ops_put);
 
 static bool bpf_struct_ops_valid_to_reg(struct bpf_map *map)
 {
-- 
2.44.0.478.gd926399ef9-goog

