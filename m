From: Mark Salyzyn <salyzyn@android.com>
Subject: Re: [PATCH v2] overlayfs: caller_credentials option bypass
 creator_cred
Date: Mon, 18 Jun 2018 12:32:13 -0700
Message-ID: <afbcabfc-2e25-d2fc-107a-5418b5e0806f@android.com>
References: <20180618192726.67981-1-salyzyn@android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180618192726.67981-1-salyzyn@android.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jonathan Corbet <corbet@lwn.net>, Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On 06/18/2018 12:27 PM, Mark Salyzyn wrote:
> All accesses to the lower filesystems reference the creator (mount)
> context.  This is a security issue as the user context does not
> overlay the creator context.
<sigh> been typing overlay far too many times, muscle memory struck!

"overlap the creator context."

-- Mark
