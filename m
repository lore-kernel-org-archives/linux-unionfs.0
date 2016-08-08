From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [RFC PATCH 0/9][V3] Overlayfs SELinux Support
Date: Mon, 8 Aug 2016 14:46:51 +0200
Message-ID: <CAJfpeguBtH=_q8KVCn-g5i9+PSMG5xj8Q+591JeF9TMF9BCnBg@mail.gmail.com>
References: <1468421095-22322-1-git-send-email-vgoyal@redhat.com>
 <CAHC9VhR7YM+VPXVO=no3bDsj4w5HZz1DiJZR5XajCEfMSYF6=g@mail.gmail.com>
 <CAJfpegtdy=yRGvxmZyvLdnYHBLdft6zzaLE5EvpCzguNcMVZvQ@mail.gmail.com> <CAHC9VhSDOcbQgn+2HRSDc4E0=5ddq3SfDicwQy-e3t_hCh65Ug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHC9VhSDOcbQgn+2HRSDc4E0=5ddq3SfDicwQy-e3t_hCh65Ug@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Moore <paul@paul-moore.com>
Cc: James Morris <jmorris@namei.org>, Vivek Goyal <vgoyal@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>, Paul Moore <pmoore@redhat.com>, Casey Schaufler <casey@schaufler-ca.com>, linux-kernel@vger.kernel.org, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, LSM <linux-security-module@vger.kernel.org>, Dan Walsh <dwalsh@redhat.com>, David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Fri, Jul 22, 2016 at 5:33 PM, Paul Moore <paul@paul-moore.com> wrote:
> On Thu, Jul 21, 2016 at 7:09 PM, James Morris <jmorris@namei.org> wrote:
>> On Thu, 21 Jul 2016, Paul Moore wrote:
>>> James, assuming the overlayfs-next branch is pulled during the merge
>>> window, can you rebase your linux-security#next branch to v4.8-rc1
>>> once Linus tags it?
>>
>> Yep.
>
> On Fri, Jul 22, 2016 at 3:05 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Thu, Jul 21, 2016 at 11:16 PM, Paul Moore <paul@paul-moore.com> wrote:
>>> Hi Vivek,
>>>
>>> These patches look fine to me, thanks for all your hard work and to
>>> everyone who helped review and provide feedback.  I have tagged these
>>> patches for merging into the SELinux next branch after this merge
>>> window.
>>>
>>> Miklos, this patchset depends on patches in your overlayfs-next
>>> branch, I assume you're pushing that branch during the upcoming merge
>>> window?
>>
>> Yes, that's the plan.
>
> Great, thanks.

Base patches are now in v4.8-rc1.

Thanks,
Miklos
