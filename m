Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793372274;
	b=jdtEc+lQX20lAbJDeZN5x8bNQFjfM6JbCSe16HltlCmRLjLYfkSQGJzrk79JS0KXYuF+
	 YS4KelECqdg631X8bckLm0o1SEIM9zSLHZiSwzi42//pB6a+DHcwybpUNP9oruzc3JbK7
	 GJoNAxLUFTIDoS4wCP9P7T+RqwfC4EGkl8T81P/8+zKlUatmgtaDSiBzksxZOpkO1LrHA
	 W6NEiuof5Rv21sYveztz8mI5ZxfioSAjy1+hf0InQwMg+9iyDgBm1vrmllAADMjjUVlYp
	 j/P4utFz74fzBlEH2piXMtYDLL0zAXc7jDStQgSV7XOnEXYRUUz4J4p46Ugrp6TuUBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793372274;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=jdzo/JB3v48SeneKPfJ1gOvJLI6gIMIp+FynceKuycM=;
	b=GmjCuaaPc4/yMDnjInyFQ3w44RCO41Jm3IupPzjTBQEiPO8DLTMORfOeG7976n1oOB4x
	 w1BpNGbRLK48pcSx9gykRj/YDtXn781uPzh3M6DLzJLntHBmH08/0XEXXo9cjfVicB6X9
	 LqiPk8ix0OThF8muD7jL4n067gOo+HqJPsC59IFI3EHvEx2maVMnA91hWUJ69OLlYP8nb
	 iA1wk4nO753GDk0IPGCjUPLWlFsNMtvj7wr9sEaA0PPtDCei+Mw3lhMV665lL3uaR3ab+
	 QrzQQ7Wz7jyamUqK4GiVeR1KKUlEOxjfhYoGDPNWc6lQq9WxeVFIDjnMfXzv37wqIug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KDtmM5U9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B0E606A31A;
	Fri, 30 Oct 2026 14:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KDtmM5U9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B83CE1F000C1;
	Fri, 30 Oct 2026 14:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793372273;
	bh=jdzo/JB3v48SeneKPfJ1gOvJLI6gIMIp+FynceKuycM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KDtmM5U9/nlLDrvkYK477BJ6l62T7j3Tq61FVrN1RPIoswoDY6osdmLedz7FG7ZNz
	 nyKKOYYn7v0PDdl6GhDXOCSvt0PDLyL6tg6tdB2J8v8QCFzgrPkU6o9H5JEhhSLjq3
	 qEPMg5AR1UnOY2EszabX7fOmdau0IquNp4c3/hNhhh8vu85TGAKqd/uURl1ccD47Oe
	 lruFjzGdBGLjW9RxSgppdcv2Cd0Zo2npHfpgHJSMNhacNU/sMyqZ6QoUnx2QnBpqu1
	 4yWH1v7l/hy8f84veiUbdKCIV3ieDDy082/rpdBxoAPQeKnIZ/wyiF/M2KTDZIhGGn
	 7PZf9dTpmujSg==
Date: Fri, 30 Oct 2026 15:57:49 +0100
From: Christian Brauner <brauner@kernel.org>
To: Edvard Conrad <edvard@tuta.io>, Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] fs: let backing files inherit FMODE_NONOTIFY from the
 user file
Message-ID: <20261030-welpen-anbinden-nullen-b2432cee1d10@brauner>
References: <P58Wrer--F-9@tuta.io>
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <P58Wrer--F-9@tuta.io>

On Thu, Oct 29, 2026 at 10:18:40PM +0100, Edvard Conrad wrote:
> Make a backing file inherit FMODE_NONOTIFY when the user file it is
> opened for must not generate events. This restores the pre-6.14
> behaviour for the fds that fanotify creates (and for any other
> FMODE_NONOTIFY file), while ordinary opens through a stacked filesystem
> keep generating events on the real path, as intended by bc2473c90fca.

Looks good to me. I'll take this via vfs.fixes and fix up the subject to
use the "backing-file:" prefix while applying.

Amir, note that the same deadlock is still there for directories.
ovl_dir_open_realfile() goes through ovl_path_open() -> dentry_open()
and not through backing_file_open(). So a FAN_OPEN_PERM|FAN_ONDIR
listener that opens an overlay directory through the fd fanotify handed
it wedges the same way. That needs to be fixed on the overlayfs side.
