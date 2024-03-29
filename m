Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2BC7C083
	for <linux-unionfs@vger.kernel.org>; Fri, 29 Mar 2024 01:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711677299; cv=none; b=rO4sHSOXbGjZeBH/+t612NS57w0Wy1EX98VrT0MI3xHcgOfkdkWWbdPuLoQYszpA3U/eYwP9pAUrw6cg78SBDeGFRSqYsLWOavjMO+5u2rq15reB0yUsyQjwT21JdVnhPZqaVekzjP9t0pQY64wuPMc1F2VNF9ojgQKyu2YDG2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711677299; c=relaxed/simple;
	bh=9iXCNP+EW0+2+JC2nl2OoNy89uZqvybM8NUQJ2K/ih4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pKziXDPWzcE6fuyB4XNHdPyvEtXHn3hYkjQG9uycfctAKwS8y9uGLGMGQDaODW7UdjURgxf7FRw3YJ6kzv7eR0zUmj6nyqUqC6JD7lnXmBqRatWdU9xg/JCPtLIr3xd/acfz+FPJuRJWtRZEAbAIvFJ+goUaEDJozOCeC8CFOBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--drosen.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RH0NkW3B; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--drosen.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RH0NkW3B"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-60ab69a9e6fso32651257b3.0
        for <linux-unionfs@vger.kernel.org>; Thu, 28 Mar 2024 18:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711677297; x=1712282097; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RmiND9fJytE7hp4aS6EZvp2Qf4FYwUyLzLHSobY4D+U=;
        b=RH0NkW3B64RQtwllzuYjxkJLeWIXvju90EGmkhpDAz0nu27JSAa8QfHI3qW91Vqow+
         eRXrh0VfoR/RqJXz9uPpOW9nnkwroxtdVxgvB4pEoRVZdrKSJ/BaFrWhT8nhwXouMuE7
         DuVQbnWdIAXCWUWT4cEr9RUtloHYA0IxI7huyL16H040Xc5u8FQg7bGz53WOyIGrEjgS
         zJS2In2dshIrjarZ0Y6nr8UbNEn9WON+ce0oQnx0RKdEoIjFOCbiLF6Cth/OKtBVlIeq
         LBEdaDwUPogsXUH6HIvcXNM472ZnUFGwQENthMc1Bc1hsSGKCE27Y7oR0gYUmYXWeaER
         4x8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711677297; x=1712282097;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RmiND9fJytE7hp4aS6EZvp2Qf4FYwUyLzLHSobY4D+U=;
        b=IfLWvkf0rb5EmNQijPQtpZ71WbaBd2TF5JMmoHiCFcLsm40vrN5jRMjXr9dnF+/lWG
         e1EZZPxLYtlF0Hrh6TfAPmhqBlsP3RPyZ9TKXw6PZvfwmx82oD2AdW7wSjFc1Jk1PIrj
         MkbFv9fmWsbUMathfEfZBKlI/Ldo6Famw71fYQz2pq5anWqvJGVGr5TSCI6948W2c81F
         7FNN+DA16eYlHmzxqd9VMI0lXpgvSdzCcPpYN54ZX7Aq5bU6I4SwZBHLeEK4ZZVG/+S3
         TQJfR8e3lOdEdONyBWDULOQnbI5YcVjsNLjOEjRflXoWTnF3wW8duVT794jhvxSnpmaW
         ys3g==
X-Forwarded-Encrypted: i=1; AJvYcCXP8cjYmOcO1F/mEY5zv4G8EyJdHH3GFxR7/SW48fQTMnFC+/tQjXwVIvnU7oHaIEXYaVP0xAQcAo4jrkn7tgx9cNypL5bnmSkEvaF0aA==
X-Gm-Message-State: AOJu0Yxrqq71l4og8FCEismYh/coeJCjqxP4/4eztN6/BZpmbjWBFlmt
	vyV6P6ggA7+henwZNIYG89y76IUNulSKMqR2ybb/KeItYhDzlNseTU2WLRknPB4eD1EcnmMfAqF
	ZcQ==
X-Google-Smtp-Source: AGHT+IHeiHkMKp379qbywYMCr+diDVdq9JP2CxLadyp3LUxzIJLjH2ayb4pU1zwCCzZ0jFp6BgvxfUk/s6M=
X-Received: from drosen.mtv.corp.google.com ([2620:15c:211:201:fcce:d6ab:804c:b94b])
 (user=drosen job=sendgmr) by 2002:a05:6902:1004:b0:dda:c4ec:7db5 with SMTP id
 w4-20020a056902100400b00ddac4ec7db5mr365495ybt.4.1711677296744; Thu, 28 Mar
 2024 18:54:56 -0700 (PDT)
Date: Thu, 28 Mar 2024 18:53:40 -0700
In-Reply-To: <20240329015351.624249-1-drosen@google.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240329015351.624249-1-drosen@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240329015351.624249-26-drosen@google.com>
Subject: [RFC PATCH v4 25/36] bpf: Increase struct_op max members
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

Fuse bpf goes a bit past the '64' limit here.
This doubles the limit, although fuse-bpf currently uses 66.

Signed-off-by: Daniel Rosenberg <drosen@google.com>
---
 include/linux/bpf.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 785660810e6a..7a5a806e97ad 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1636,7 +1636,7 @@ struct bpf_token {
 struct bpf_struct_ops_value;
 struct btf_member;
 
-#define BPF_STRUCT_OPS_MAX_NR_MEMBERS 64
+#define BPF_STRUCT_OPS_MAX_NR_MEMBERS 128
 /**
  * struct bpf_struct_ops - A structure of callbacks allowing a subsystem to
  *			   define a BPF_MAP_TYPE_STRUCT_OPS map type composed
-- 
2.44.0.478.gd926399ef9-goog

