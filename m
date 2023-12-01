Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AFA04AF7C;
	Fri,  1 Dec 2023 15:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u7UxdtxI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC8FCC433C8;
	Fri,  1 Dec 2023 15:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701445839;
	bh=SyIC/HkVOiHxd5aY9Ss3kPjVyeje4JbpChA97X9KnfQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=u7UxdtxIA/ZDwTc6kU3tarNl4O/39gFz7JPd0ZY9plzGETGRc8h7KX7VnFZEL+vTs
	 zKDsDLLlo3W4IDdkoYYZFABL9N1MloskLuno/bSJ/NxsQFBNjupSWVIVWxUG1+IGtl
	 j2c4Y34Ek8oE4JAnVb9fnOSJC7CzFnFpuHkGM6G0phuyKrk5dQHbQPVJ+7vUVFIjiZ
	 oEcqEyuiwNU9Sv2/IdOgeRk5poLANGfX2k8aid9KYB/7zgEsjA3LjpYq/dxjF6Fs+w
	 W+Ozxa8waEGdHrXo1hEoE5pjWXYoxIuUFVYcXrqtTtIcNApXXz4zPT5/csUgHMbX5Z
	 gfPh563wlvfzA==
Date: Fri, 1 Dec 2023 16:50:34 +0100
From: Christian Brauner <brauner@kernel.org>
To: "Seth Forshee (DigitalOcean)" <sforshee@kernel.org>
Cc: Serge Hallyn <serge@hallyn.com>, Paul Moore <paul@paul-moore.com>,
	Eric Paris <eparis@redhat.com>, James Morris <jmorris@namei.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org, audit@vger.kernel.org,
	linux-unionfs@vger.kernel.org
Subject: Re: [PATCH 03/16] capability: rename cpu_vfs_cap_data to vfs_caps
Message-ID: <20231201-anregen-haifisch-02bb75192a7a@brauner>
References: <20231129-idmap-fscap-refactor-v1-0-da5a26058a5b@kernel.org>
 <20231129-idmap-fscap-refactor-v1-3-da5a26058a5b@kernel.org>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231129-idmap-fscap-refactor-v1-3-da5a26058a5b@kernel.org>

On Wed, Nov 29, 2023 at 03:50:21PM -0600, Seth Forshee (DigitalOcean) wrote:
> vfs_caps is a more generic name which is better suited to the broader
> use this struct will see in subsequent commits.
> 
> Signed-off-by: Seth Forshee (DigitalOcean) <sforshee@kernel.org>
> ---

Yep, looks good to me,
Reviewed-by: Christian Brauner <brauner@kernel.org>
