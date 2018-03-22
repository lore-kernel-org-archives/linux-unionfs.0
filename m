MIME-Version: 1.0
In-Reply-To: <CAOQ4uxjCRLPzZ4y8Ak-SOBfa1-t7rAaRAveJHHfde0fnkgn0Sw@mail.gmail.com>
References: <1520767374-19374-1-git-send-email-amir73il@gmail.com>
	<1520767374-19374-4-git-send-email-amir73il@gmail.com>
	<CAJfpegtgJWinj=81rdm9+8VjTo8PDnNPU8d587dvaZj6X1nvQA@mail.gmail.com>
	<CAOQ4uxhZEneTh3+Fa9h4resHge8ODQwD8ti7Hqj7WE5QF5J0+w@mail.gmail.com>
	<CAOQ4uxjCRLPzZ4y8Ak-SOBfa1-t7rAaRAveJHHfde0fnkgn0Sw@mail.gmail.com>
Date: Thu, 22 Mar 2018 16:34:03 +0100
Message-ID: <CAJfpegtDmjZOepc=TMQ1CtzhhmmBX4KiXChUej15kAiYsxThVA@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] ovl: lookup in inode cache first when decoding
 lower file handle
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Mar 22, 2018 at 4:20 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Thu, Mar 22, 2018 at 1:55 PM, Amir Goldstein <amir73il@gmail.com> wrote:

> Yes, it is a mistake as you observed.
> I was trying to understand why it didn't affect the tests.
>
> Apparently, the case where underlying dentry is disconnected
> and overlay inode is in cache is harder to reproduce and is not covered by
> the current tests. I think it requires:
> - encoding non-upper non-dir overlay file handle
> - drop caches
> - open by non-upper file handle (disconnected underlying and not in
> overlay icache)
> - open by non-upper file handle again (disconnected underlying and in
> overlay icache)
>
> The current tests only cover:
> - encoding non-upper non-dir overlay file handle
> - drop caches
> - open by non-upper file handle (disconnected underlying and not in
> overlay icache)
> AND:
> - encoding non-upper non-dir overlay file handle AND keep the file open
> - drop caches
> - open by non-upper file handle (connected underlying and in overlay icache)
>
> I will add the missing tests to my TODO.
> I suppose you will be fixing this bug on commit?

Yes.

Thanks,
Miklos
