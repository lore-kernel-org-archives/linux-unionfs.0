Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0279C2741C9
	for <linux-unionfs@vger.kernel.org>; Thu, 19 Mar 2026 19:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773946984; cv=none; b=EHKss+ik9Bf59MvKF/kZsIlS1ps7geiyCv259f7LHEuFta9CAFtAxanm9cJJZg1jzWQSFSd/uOla+vj01tKJJBzXzo+0ar1UXVfwHZoxDiTfR8shUoOFKGlztLQKaWs9T6Rr8PFD0o1C+p2+DfIYp7xYmYSAy5hfhcgZXk71CgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773946984; c=relaxed/simple;
	bh=crSjcue+IfsXTmT2xZQYzZd8QtOPpPIkDYJZpEMEBdg=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=oclIL/IMf9k9ytK+Tsw9XwuvtRKDUOFSITWuWUcZv/SAy4njaOs0v6XwUwqq3RxjRAweeFzq2uT17TU49aMn3WcqQkXIM91HnYezdLaZXUx7QQGfAqwrnO4L09iPYiwFLSAmvmXw4gz0oG+hxWztlXZxnadHsYVOup40ObxWD80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-463a1cee56aso9720759b6e.0
        for <linux-unionfs@vger.kernel.org>; Thu, 19 Mar 2026 12:03:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773946982; x=1774551782;
        h=content-transfer-encoding:to:from:subject:message-id:in-reply-to
         :date:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BYqngK77oMjnwirz58bwbt9XcUfomTFn+3M8Rkfh/tA=;
        b=n1CS3tQC7C+mWtrJm+7+FO6cu+bLIMxJ1dlPaasb+NV2ZQ9V8+uG5e08jG/4Cg2w3q
         quZNY9x7BDuxyLgFdkI+j74INPBzyrSCVoWnQu8m/D1OmrUuKL/Fj/+Mz802+xuuFdtE
         2xS1SxCQ44/8vuVW0843j7Zb74vFvaTeNInD0UVd0DWB2hIAgpJWtHC1CdsjEYDGAJsh
         W5mlWZ9GFiqgBvCpOToQA1Y2xA2n5QUnb8l4UurUF4A7DSUlsaVaQ0OwJjouATTPRJKW
         b5V7PdPUMCfI1ncavbbc+uvsoSaPqDPMZ0Vl4f8DjtdY0OcsC3+qriwGQy/p6Y5VR7sU
         pTLA==
X-Forwarded-Encrypted: i=1; AJvYcCVouR79PjhNbeL6TTRrkf6VYbeveBXdYDDfZYqMSxjSsULlONwxNAbUD8jzwf5vSAR16ie3RmgUQrV6kH0g@vger.kernel.org
X-Gm-Message-State: AOJu0Yxp+Me6i2ZxzrpFUOXrVMA4PYTzw0obek/CufLH3aBmLcBwE06F
	J68hjpdYj/Rglx9WvGgIRfpPBFnm+fHbjQPCpTIHqUJwHtxS8qpv+zrGXKKhUVueNOK6sN99MBR
	d7AIIwtK4hFhtabfuWj8y/RamDog+uRKy9XIgU8wJ8M62gJmGpsLgexE2hzc=
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6870:788b:b0:3f1:6d93:4386 with SMTP id
 586e51a60fabf-41c10e8098fmr270411fac.1.1773946981919; Thu, 19 Mar 2026
 12:03:01 -0700 (PDT)
Date: Thu, 19 Mar 2026 12:03:01 -0700
In-Reply-To: <CAOQ4uxgKgWi_ro2nGKkFuDFP9vPne_hRSNmfFiwxCQ6TjjH0tw@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69bc4865.a00a0220.125422.0002.GAE@google.com>
Subject: Re: [syzbot] [overlayfs?] general protection fault in do_dentry_open
From: syzbot <syzbot+f34aab278bf5d664e2be@syzkaller.appspotmail.com>
To: amir73il@gmail.com, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, miklos@szeredi.hu, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

failed to create instance: googleapi: Error 400: Invalid value for field 'r=
esource.scheduling.preemptible': 'false'. Scheduling must have preemptible =
be false when OnHostMaintenance isn't TERMINATE., invalid



syzkaller build log:
go env (err=3D<nil>)
AR=3D'ar'
CC=3D'gcc'
CGO_CFLAGS=3D'-O2 -g'
CGO_CPPFLAGS=3D''
CGO_CXXFLAGS=3D'-O2 -g'
CGO_ENABLED=3D'1'
CGO_FFLAGS=3D'-O2 -g'
CGO_LDFLAGS=3D'-O2 -g'
CXX=3D'g++'
GCCGO=3D'gccgo'
GO111MODULE=3D'auto'
GOAMD64=3D'v1'
GOARCH=3D'amd64'
GOAUTH=3D'netrc'
GOBIN=3D''
GOCACHE=3D'/syzkaller/.cache/go-build'
GOCACHEPROG=3D''
GODEBUG=3D''
GOENV=3D'/syzkaller/.config/go/env'
GOEXE=3D''
GOEXPERIMENT=3D''
GOFIPS140=3D'off'
GOFLAGS=3D''
GOGCCFLAGS=3D'-fPIC -m64 -pthread -Wl,--no-gc-sections -fmessage-length=3D0=
 -ffile-prefix-map=3D/tmp/go-build1926708935=3D/tmp/go-build -gno-record-gc=
c-switches'
GOHOSTARCH=3D'amd64'
GOHOSTOS=3D'linux'
GOINSECURE=3D''
GOMOD=3D'/syzkaller/jobs/linux/gopath/src/github.com/google/syzkaller/go.mo=
d'
GOMODCACHE=3D'/syzkaller/jobs/linux/gopath/pkg/mod'
GONOPROXY=3D''
GONOSUMDB=3D''
GOOS=3D'linux'
GOPATH=3D'/syzkaller/jobs/linux/gopath'
GOPRIVATE=3D''
GOPROXY=3D'https://proxy.golang.org,direct'
GOROOT=3D'/usr/local/go'
GOSUMDB=3D'sum.golang.org'
GOTELEMETRY=3D'local'
GOTELEMETRYDIR=3D'/syzkaller/.config/go/telemetry'
GOTMPDIR=3D''
GOTOOLCHAIN=3D'auto'
GOTOOLDIR=3D'/usr/local/go/pkg/tool/linux_amd64'
GOVCS=3D''
GOVERSION=3D'go1.26.0'
GOWORK=3D''
PKG_CONFIG=3D'pkg-config'

git status (err=3D<nil>)
HEAD detached at c01bca74391
nothing to commit, working tree clean


tput: No value for $TERM and no -T specified
tput: No value for $TERM and no -T specified
Makefile:31: run command via tools/syz-env for best compatibility, see:
Makefile:32: https://github.com/google/syzkaller/blob/master/docs/contribut=
ing.md#using-syz-env
go list -f '{{.Stale}}' -ldflags=3D"-s -w -X github.com/google/syzkaller/pr=
og.GitRevision=3Dc01bca7439117559131c7afa36f261a369581611 -X github.com/goo=
gle/syzkaller/prog.gitRevisionDate=3D20260317-064358"  ./sys/syz-sysgen | g=
rep -q false || go install -ldflags=3D"-s -w -X github.com/google/syzkaller=
/prog.GitRevision=3Dc01bca7439117559131c7afa36f261a369581611 -X github.com/=
google/syzkaller/prog.gitRevisionDate=3D20260317-064358"  ./sys/syz-sysgen
make .descriptions
tput: No value for $TERM and no -T specified
tput: No value for $TERM and no -T specified
Makefile:31: run command via tools/syz-env for best compatibility, see:
Makefile:32: https://github.com/google/syzkaller/blob/master/docs/contribut=
ing.md#using-syz-env
bin/syz-sysgen
touch .descriptions
GOOS=3Dlinux GOARCH=3Damd64 go build -ldflags=3D"-s -w -X github.com/google=
/syzkaller/prog.GitRevision=3Dc01bca7439117559131c7afa36f261a369581611 -X g=
ithub.com/google/syzkaller/prog.gitRevisionDate=3D20260317-064358"  -o ./bi=
n/linux_amd64/syz-execprog github.com/google/syzkaller/tools/syz-execprog
mkdir -p ./bin/linux_amd64
g++ -o ./bin/linux_amd64/syz-executor executor/executor.cc \
	-m64 -O2 -pthread -Wall -Werror -Wparentheses -Wunused-const-variable -Wfr=
ame-larger-than=3D16384 -Wno-stringop-overflow -Wno-array-bounds -Wno-forma=
t-overflow -Wno-unused-but-set-variable -Wno-unused-command-line-argument -=
static-pie -std=3Dc++17 -I. -Iexecutor/_include   -DGOOS_linux=3D1 -DGOARCH=
_amd64=3D1 \
	-DHOSTGOOS_linux=3D1 -DGIT_REVISION=3D\"c01bca7439117559131c7afa36f261a369=
581611\"
/usr/bin/ld: /tmp/ccLeYWkg.o: in function `Connection::Connect(char const*,=
 char const*)':
executor.cc:(.text._ZN10Connection7ConnectEPKcS1_[_ZN10Connection7ConnectEP=
KcS1_]+0x386): warning: Using 'gethostbyname' in statically linked applicat=
ions requires at runtime the shared libraries from the glibc version used f=
or linking
./tools/check-syzos.sh 2>/dev/null



Tested on:

commit:         045aba2b fs: allow vfs code to open an O_PATH file wit..
git tree:       https://github.com/amir73il/linux.git vfs-fixes
kernel config:  https://syzkaller.appspot.com/x/.config?x=3D6fb7e86cc0b17d7=
8
dashboard link: https://syzkaller.appspot.com/bug?extid=3Df34aab278bf5d664e=
2be
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-=
1~exp1~20251221153213.50), Debian LLD 21.1.8

Note: no patches were applied.
