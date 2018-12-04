From: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: overlayfs access checks on underlying layers
Date: Tue, 4 Dec 2018 10:35:17 -0500
Message-ID: <6feb656e-b1e3-5839-ce5f-669ae5a55b7f@tycho.nsa.gov>
References: <CAJfpegs9JjkXguemL4qSiBvRP6Dnut-D+nJo-oLFXkfCL1Egvw@mail.gmail.com>
 <CAJfpegvfqx+0D32n1h2X7oj5d1mZWiLTcSSGpBnD+ba7AKzPyA@mail.gmail.com>
 <20181127210542.GA2599@redhat.com>
 <CAJfpegtQGM2z9TOt3DWwd39fC60cQknsC4vNnj7YimVEubRzUg@mail.gmail.com>
 <20181128170302.GA12405@redhat.com>
 <377b7d4f-eb1d-c281-5c67-8ab6de77c881@tycho.nsa.gov>
 <CAJfpegtNhcWD0VWy6LPtoDtQBfPu4x5iFsB053UMCidj6oMsuw@mail.gmail.com>
 <26bce3be-49c2-cdd8-af03-1a78d0f268ae@tycho.nsa.gov>
 <CAJfpeguL9xOh9Eq8LOP=ddJ4YD6nbp2UY6e2AYDVoHeCLuVhZA@mail.gmail.com>
 <6b125e8e-413f-f8e6-c7ae-50f7235c8960@tycho.nsa.gov>
 <CAJfpegv6y56k1-Tewu-Pu3x1W75LL6qYB6Hb6=n+2BJoNfEigA@mail.gmail.com>
 <c993dba4-5129-7f04-2724-a82a1f1cafa3@tycho.nsa.gov>
 <f84bbe0b-f4c1-50e0-8c84-a6589154b3ae@tycho.nsa.gov>
 <CAJfpegtBDTMbmKd6eDxRmtSJjGN6CnpGK_QPNSsxjkOoeu=1pQ@mail.gmail.com>
 <4c20a261-5ce1-f0a2-8d40-c6032a023216@tycho.nsa.gov>
 <CAJfpegujwNpWL5Eujrb+=EQF8OMOkO03yq8ZZSkfhFfwQvhGKQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJfpegujwNpWL5Eujrb+=EQF8OMOkO03yq8ZZSkfhFfwQvhGKQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Ondrej Mosnacek <omosnace@redhat.com>, "J. Bruce Fields" <bfields@fieldses.org>, Mark Salyzyn <salyzyn@android.com>, Paul Moore <paul@paul-moore.com>, linux-kernel@vger.kernel.org, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, selinux@vger.kernel.org, Daniel J Walsh <dwalsh@redhat.com>
List-Id: linux-unionfs@vger.kernel.org

On 12/4/18 9:45 AM, Miklos Szeredi wrote:
> On Tue, Dec 4, 2018 at 3:28 PM Stephen Smalley <sds@tycho.nsa.gov> wrote:
>>
>> On 12/4/18 8:32 AM, Miklos Szeredi wrote:
> 
>>> My proposed sequence would be
>>>
>>> a) check task's creds against overlay inode, fail -> return fail, otherwise:
>>> b) check mounter's creds against lower inode, success -> return
>>> success, otherwise:
>>> c) copy up inode, fail -> return fail, otherwise
>>> d) check mounter's creds against upper inode, return result.
>>>
>>> So, unlike write access to regular files, write access to special
>>> files don't necessarily result in copy-up.
>>>
>>> You say this is an escalation of privilege, but I don't get it how.
>>> As DWalsh points out downthread, if mounter cannot create device
>>> files, then the copy-up will simply fail.  If mounter can create
>>> device files, then this is not an escalation of privilege for the
>>> mounter.
>>
>> Yes, in that case there isn't an escalation of privilege for the mounter
>> (I acknowledged that above).  I'm still not sure copy-up of special
>> files is a good idea though:
>>
>> - In the case of device files, there is the potential for mischief by
>> the client task in misusing the mounter's privileges to gain access to
>> otherwise unusable device node (nodev lower vs upper?),
> 
> The mount flag "nodev" on lower or upper has no effect on the overlay,
> and never had.
> 
>> - In the case of sockets or fifos, what useful result do you get from a
>> copy-up? Accessing the copy isn't going to yield the same result as
>> accessing the original.
> 
> This is a misconception.  Overlayfs is a filesystem (that uses other
> filesystems as backing store), but it's more a filesystem and less a
> vfs hack (and trying to completely get out of the vfs hack business),
> and copy up has no effect on I/O being performed on a socket or FIFO:
> it's the same object before and after the copy up, and it's a
> different object from either the lower or upper nodes.   Same as NFS:
> fifo on server is logically different object than fifo having the same
> name on any number of clients.
> 
>> For executables, this copy-up behavior might trigger a lot of undesired
>> copies of non-executable files from the lower dir into the upper, even
>> if we ultimately end up denying the execute.
> 
> That would only happen if
> 
>    - task is allowed exec on overlay
>    - mounter is denied exec on lower
>    - copy up is allowed
>    - mounter is denied exec on upper
> 
> In fact in the model where upper object inherits context from overlay
> this is pretty much impossible, AFAICT.

I think the above is the situation in Android (mounter is denied exec to 
lower and upper to prevent unauthorized code execution, but is allowed 
to copy-up in order to support writes by the client).  However, since 
they need override_creds=off or similar anyway, I guess it doesn't matter.

Ok, I concede the point.  Not sure what that means though for v4.20.
